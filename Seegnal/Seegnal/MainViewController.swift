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
        configure()
    }

    // 카메라 정지
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.global().async {
            self.session.stopRunning()
        }
    }
    
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
    // MARK: - configure
    
    func configure() {
        view.addSubview(captureButton)
        view.addSubview(flashbutton)
        view.addSubview(zoomButton)
        view.addSubview(switchButton)
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
//        previewLayer.videoGravity = .resizeAspectFill
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


    // 카메라 캡쳐 델리게이트 메서드
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // 카메라 화면 캡쳐 데이터 처리
    }

    // 이미지 캡쳐 메서드
    @objc func captureImage() {
        
        // photoSettings 객체 생성
        let photoSettings = AVCapturePhotoSettings(format: [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)])

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
        
        // 카메라 정지
        DispatchQueue.global().async {
            self.session.stopRunning()
            
            // 5초 후 카메라 다시 작동
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                DispatchQueue.global().async {
                    self.session.startRunning()
                }
                
                // 캡처된 이미지 제거
                DispatchQueue.main.async {
                    if let capturedImageView = self.view.viewWithTag(999) {
                        capturedImageView.removeFromSuperview()
                    }
                }
            }
        }
    }
}
