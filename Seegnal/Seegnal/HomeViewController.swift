//
//  HomeViewController.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/30.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        // Do any additional setup after loading the view.
    }
    
    let guideConstant = 10.0
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Seegnal"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .blue.withAlphaComponent(0.5)
        label.textAlignment = .center
        return label
    }()
    
    private let captioningButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("상황 읽기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        
        button.setTitleShadowColor(nil, for: .normal)
        button.titleLabel?.shadowOffset = CGSize.zero
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let ocrButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("글자 읽기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        
        button.setTitleShadowColor(nil, for: .normal)
        button.titleLabel?.shadowOffset = CGSize.zero
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func configure() {
        
        self.navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
        
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: guideConstant).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: guideConstant).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: guideConstant).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -guideConstant).isActive = true
        
        stackView.addSubview(captioningButton)
        
        captioningButton.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        captioningButton.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.49).isActive = true
        captioningButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0).isActive = true
        
        stackView.addSubview(ocrButton)
        
        ocrButton.heightAnchor.constraint(equalTo:stackView.heightAnchor, multiplier: 0.49).isActive = true
        ocrButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        ocrButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0).isActive = true
        
        captioningButton.addTarget(self, action: #selector(captionButtonTapped), for: .touchUpInside)
        ocrButton.addTarget(self, action: #selector(ocrButtonTapped), for: .touchUpInside)
    }
    
    @objc func captionButtonTapped() {
        let captionVC = CaptioningViewController()
        self.navigationController?.pushViewController(captionVC, animated: true)
    }

    @objc func ocrButtonTapped() {
        let ocrVC = OCRViewController()
        self.navigationController?.pushViewController(ocrVC, animated: true)
    }

}
