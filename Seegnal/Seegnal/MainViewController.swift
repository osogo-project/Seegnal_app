//
//  ViewController.swift
//  Seegnal
//
//  Created by Hoon on 2023/04/15.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // 카메라 입력 장치
    var captureDevice: AVCaptureDevice!
    // 세션
    var session: AVCaptureSession!
    // 카메라 화면 출력 뷰
    var previewLayer: AVCaptureVideoPreviewLayer!
    // 이미지뷰
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        
        // 이미지뷰 초기화
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        view.addSubview(imageView)
        
        // 미리보기 화면 위에 UIImageView 추가
        let previewImageView = UIImageView(frame: previewLayer.frame)
        view.addSubview(previewImageView)
        
        // 버튼 추가
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: view.bounds.width / 2 - 25, y: view.bounds.height - 100, width: 50, height: 50)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        view.addSubview(button)

        // 카메라 시작
        session.beginConfiguration()
        session.commitConfiguration()
        session.startRunning()
    }
    
    // 카메라 캡쳐 델리게이트 메서드
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // 카메라 화면 캡쳐 데이터 처리
    }
    
    // 이미지 캡쳐 메서드
    @objc func captureImage() {
        // photoOutput 객체 생성
        let photoOutput = AVCapturePhotoOutput()

        // photoSettings 객체 생성
        let photoSettings = AVCapturePhotoSettings(format: [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)])

        // photoOutput 객체의 capturePhoto 메서드를 호출하여 캡처 수행
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    // 카메라 정지
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
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
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        imageView.tag = 999
        view.addSubview(imageView)
        
        // 카메라 정지
        session.stopRunning()
    }
}
