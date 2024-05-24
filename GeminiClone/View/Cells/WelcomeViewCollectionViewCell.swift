//
//  WelcomeViewCollectionViewCell.swift
//  GeminiClone
//
//  Created by Altan on 24.05.2024.
//

import UIKit

class WelcomeViewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "WelcomeViewCollectionViewCell"
    
    private lazy var promptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = "Prompt Label Added"
        return label
    }()
    
    private lazy var promptImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .label
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureView() {
        layer.masksToBounds = true
        layer.cornerRadius = 13
        backgroundColor = .secondarySystemBackground
        addSubviews(promptLabel, promptImage)
    }
    
    public func configure(prompt: String, image: String) {
        promptLabel.text = prompt
        promptImage.image = UIImage(systemName: "\(image)")
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            promptLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            promptLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            promptLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            promptLabel.heightAnchor.constraint(equalToConstant: 17),
            
            promptImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            promptImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            promptImage.heightAnchor.constraint(equalToConstant: 30),
            promptImage.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
