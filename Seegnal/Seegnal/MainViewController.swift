//
//  ViewController.swift
//  Seegnal
//
//  Created by Hoon on 2023/04/15.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCamera()
        setUpTTS()
        configure()
    }

    // 카메라 정지
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.global().async {
            self.session.stopRunning()
        }
    }
    // MARK: - Timer For Peformance Test
    
    var startTime: DispatchTime!
    var endTime: DispatchTime!
    
    // MARK: - Variables
    
    // 카메라 입력 장치
    var captureDevice: AVCaptureDevice!
    // 세션
    var session: AVCaptureSession!
    // 카메라 화면 출력 preview
    var previewLayer: AVCaptureVideoPreviewLayer!
    // 이미지뷰
    var imageView: UIImageView!
    // 카메라 캡쳐 결과
    var photoOutput: AVCapturePhotoOutput!
    // TTS Speaker
    var synthesizer: AVSpeechSynthesizer!
    
    // MARK: - Buttons
    
    // flash button
    private lazy var flashbutton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bolt.circle"), for: .normal)
        button.tintColor = .white
        button.frame = CGRect(x: view.bounds.origin.x + 20, y: 60, width: 30, height: 30)
        button.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
        return button
    }()
    
    // zoom button -> Scrollable?
    private lazy var zoomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "button.programmable"), for: .normal)
        button.tintColor = .white
        button.frame = CGRect(x: view.bounds.origin.x + 60, y: 60, width: 30, height: 30)
        button.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        return button
    }()
    
    // switch side
    private lazy var switchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        button.tintColor = .white
        button.frame = CGRect(x: view.bounds.width - 70, y: view.bounds.height - 90, width: 40, height: 40)
        button.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
        return button
    }()
    
    // 캡처 버튼 추가
    private lazy var captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "button.programmable"), for: .normal)
        button.frame = CGRect(x: view.bounds.width / 2 - 35, y: view.bounds.height - 100, width: 70, height: 70)
        button.tintColor = .white
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        return button
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.frame = CGRect(x: view.bounds.width - 40, y: 60, width: 30, height: 30)
        button.tintColor = .white
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        return button
    }()
    // MARK: - configure
    
    func configure() {
        view.addSubview(captureButton)
        view.addSubview(flashbutton)
//        view.addSubview(zoomButton)
        view.addSubview(switchButton)
        view.addSubview(infoButton)
    }
    
    func setUpCamera() {
        
        // camera session pipeline 설정
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        // 카메라 입력 장치 설정
        captureDevice = AVCaptureDevice.default(for: .video)
        let input = try! AVCaptureDeviceInput(device: captureDevice)
        
        // 카메라 출력 설정
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
        
        // 세션에 입력, 출력 추가
        session.addInput(input)
        session.addOutput(output)

        // 카메라 화면 출력 뷰 초기화
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.layer.addSublayer(previewLayer)
        
        // 이미지뷰 초기화
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        view.addSubview(imageView)
        
        // 미리보기 화면 위에 UIImageView 추가
        let previewImageView = UIImageView(frame: previewLayer.frame)
        view.addSubview(previewImageView)
        
        // 결과 출력
        photoOutput = AVCapturePhotoOutput()
        
        session.addOutput(photoOutput)
        let availableFormats = photoOutput.availablePhotoCodecTypes
        
        // 카메라 시작
        DispatchQueue.global().async {
            self.session.beginConfiguration()
            self.session.commitConfiguration()
            self.session.startRunning()
        }
        
        // pinchGesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        view.addGestureRecognizer(pinchGesture)
    }
    
    func setUpTTS() {
        self.synthesizer = AVSpeechSynthesizer()
    }

    // 카메라 캡쳐 델리게이트 메서드
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // 카메라 화면 캡쳐 데이터 처리
    }
}

extension MainViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // 사진 데이터 처리
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
            print("Error: failed to get image data")
            return
        }
        // 캡처한 이미지를 미리보기로 보여주는 뷰에 표시
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        imageView.tag = 999
        self.view.addSubview(imageView)
        

        
        if let image = imageView.image {
            //        if let imageData = image.jpegData(compressionQuality: 0.5) {
            //            let imageRequest = ImageRequest(image: image)
            //            apiCall(imageRequest)
            //            self.startTime = DispatchTime.now()
            //        }
            let imageRequest = ImageRequest(image: image)
            apiCall(imageRequest)
            self.startTime = DispatchTime.now()
        } else {
            // 이미지가 nil 일 때, 처리할 코드
            // 경고창 띄울 예정
            print("There is Error Try Again")
        }
        // 카메라 정지
        DispatchQueue.global().async {
            self.session.stopRunning()
        }
    }
}


// MARK: - Objc function

extension MainViewController {
    
    // 이미지 캡쳐 메서드
    @objc func captureImage() {
        
        // photoSettings 객체 생성
        // [875704422->6.3, 875704438->6.8, 1111970369->6.9]
        let photoSettings = AVCapturePhotoSettings(format: [kCVPixelBufferPixelFormatTypeKey as String: Int(875704422)])

        // photoOutput 객체의 capturePhoto 메서드를 호출하여 캡처 수행
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    // pinchGesture 지원
    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let device = captureDevice else { return }

        do {
            try device.lockForConfiguration()

            // 줌 인/아웃 비율 계산
            let zoomScale = min(max(CGFloat(gestureRecognizer.scale), device.minAvailableVideoZoomFactor), device.maxAvailableVideoZoomFactor)

            device.videoZoomFactor = CGFloat(zoomScale)
            device.unlockForConfiguration()

        } catch {
            print("Error: Unable to lock device for configuration")
        }
    }
    
    @objc func zoomIn() {
        guard let device = captureDevice else { return }
        try? device.lockForConfiguration()
        device.videoZoomFactor = min(device.videoZoomFactor * 1.5, device.activeFormat.videoMaxZoomFactor)
        device.unlockForConfiguration()
    }

    @objc func zoomOut() {
        guard let device = captureDevice else { return }
        try? device.lockForConfiguration()
        device.videoZoomFactor = max(device.videoZoomFactor / 1.5, 1.0)
        device.unlockForConfiguration()
    }

    @objc func toggleFlash() {
        let currentFlashMode = photoOutput.photoSettingsForSceneMonitoring?.flashMode ?? .off

        switch currentFlashMode {
        case .off:
            photoOutput.photoSettingsForSceneMonitoring?.flashMode = .on
        case .on:
            photoOutput.photoSettingsForSceneMonitoring?.flashMode = .auto
        case .auto:
            photoOutput.photoSettingsForSceneMonitoring?.flashMode = .off
        @unknown default:
            photoOutput.photoSettingsForSceneMonitoring?.flashMode = .off
        }
    }

    @objc func switchCamera() {
        // 현재 카메라 위치 가져오기
        guard let currentInput = session.inputs.first as? AVCaptureDeviceInput else { return }
        let currentPosition = currentInput.device.position
        
        // 새 카메라 위치 설정
        let newPosition: AVCaptureDevice.Position = currentPosition == .back ? .front : .back
        
        // 새 카메라 장치 찾기
        guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition) else { return }
        
        // 입력 및 출력 변경
        do {
            let newInput = try AVCaptureDeviceInput(device: newDevice)
            
            session.beginConfiguration()
            session.removeInput(currentInput)
            if session.canAddInput(newInput) {
                session.addInput(newInput)
            } else {
                session.addInput(currentInput)
            }
            session.commitConfiguration()
        } catch {
            print("Error switching camera: \(error)")
        }
    }
    
    @objc func infoButtonTapped() {
        let infoVC = InfoViewController()
        self.present(infoVC, animated: true)
    }
}


// MARK: - API call

extension MainViewController {
    
    private func apiCall(_ imageRequest: ImageRequest) {
        APIClient.shared.imageCaptioning.requestImage(imageRequest) { [weak self] result in
            switch result {
            case .success(let tts):
                self?.endTime = DispatchTime.now()
                let elapsedTime = (self?.endTime.uptimeNanoseconds ?? 0) - (self?.startTime.uptimeNanoseconds ?? 0)
                let alertController = UIAlertController(title: "경과시간", message: "\(Double(elapsedTime)/1000000000)초", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                DispatchQueue.main.async {
                    DispatchQueue.global().async {
                        self?.session.startRunning()
                    }
                    let utterance = AVSpeechUtterance(string: tts.text)
                    self?.synthesizer.speak(utterance)
                    self?.present(alertController, animated: true)
                    if let capturedImageView = self?.view.viewWithTag(999) {
                        capturedImageView.removeFromSuperview()
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "경고", message: "오류가 발생했습니다. 다시 시도하세요", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                DispatchQueue.main.async {
                    self?.present(alertController, animated: true)
                }
            }
        }
    }
}

