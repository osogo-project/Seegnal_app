//
//  OptionCollectionViewCell.swift
//  Seegnal
//
//  Created by Hoon on 2023/05/31.
//

import UIKit

class OptionCollectionViewCell: UICollectionViewCell {
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(optionLabel)
        NSLayoutConstraint.activate([
            optionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            optionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            optionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            optionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        optionLabel.text = title
    }
}
