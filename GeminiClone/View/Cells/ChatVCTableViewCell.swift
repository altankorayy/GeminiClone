//
//  ChatVCTableViewCell.swift
//  GeminiClone
//
//  Created by Altan on 8.05.2024.
//

import UIKit
import SwiftyMarkdown

class ChatVCTableViewCell: UITableViewCell {

    static let identifier = "ChatVCTableViewCell"
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.tintColor = .label
        return imageView
    }()
    
    public lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private var contentImageViewHeightConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureView() {
        selectionStyle = .none
        contentView.addSubviews(profileImageView, messageLabel, contentImageView)
    }
    
    private func configureConstraints() {
        contentImageViewHeightConstraint = contentImageView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            contentImageView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            contentImageView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            contentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            contentImageViewHeightConstraint
        ])
    }
    
    public func configure(_ text: ChatMessage) {
        let markdownText = SwiftyMarkdown(string: text.message)
        messageLabel.attributedText = markdownText.attributedString()
        
        if text.participant == .user {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
        } else {
            profileImageView.image = UIImage(named: "geminiLogo")
        }
        
        if let image = text.image {
            contentImageView.image = image
            contentImageView.isHidden = false
            contentImageViewHeightConstraint.constant = 200
        } else {
            contentImageView.isHidden = true
            contentImageViewHeightConstraint.constant = 0
        }
        layoutIfNeeded()
    }
}
