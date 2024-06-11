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
    
    private lazy var messageBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        view.layer.cornerRadius = 10
        return view
    }()
    
    public lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
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
    private var messageBackgroundViewLeadingConstraint: NSLayoutConstraint!
    
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
        contentView.addSubviews(profileImageView, messageBackgroundView, contentImageView)
        messageBackgroundView.addSubview(messageLabel)
    }
    
    private func configureConstraints() {
        contentImageViewHeightConstraint = contentImageView.heightAnchor.constraint(equalToConstant: 200)
        messageBackgroundViewLeadingConstraint = messageBackgroundView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            
            messageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageBackgroundViewLeadingConstraint,
            messageBackgroundView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
            
            messageLabel.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: -10),
            messageLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -10),
            
            contentImageView.topAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: 10),
            contentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48),
            contentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            contentImageViewHeightConstraint
        ])
    }
    
    public func configure(_ text: ChatMessage) {
        let markdownText = SwiftyMarkdown(string: text.message)
        messageLabel.attributedText = markdownText.attributedString()
        
        if text.participant == .user {
            messageLabel.textAlignment = .right
            profileImageView.isHidden = true
            messageBackgroundViewLeadingConstraint.isActive = false
            messageBackgroundView.backgroundColor = UIColor.systemBlue
            messageLabel.textColor = .white
        } else {
            messageLabel.textAlignment = .left
            profileImageView.isHidden = false
            profileImageView.image = UIImage(named: "geminiLogo")
            messageBackgroundViewLeadingConstraint.isActive = true
            messageBackgroundView.backgroundColor = UIColor.secondarySystemBackground
        }
        
        if let image = text.image {
            contentImageView.image = image
            contentImageView.isHidden = false
            contentImageViewHeightConstraint.constant = 200
        } else {
            contentImageView.isHidden = true
            contentImageViewHeightConstraint.constant = 0
        }
        contentView.layoutIfNeeded()
        contentView.setNeedsLayout()
    }
}
