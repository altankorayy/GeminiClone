//
//  SystemChatTableViewCell.swift
//  GeminiClone
//
//  Created by Altan on 15.06.2024.
//

import UIKit
import SwiftyMarkdown

class SystemChatTableViewCell: UITableViewCell {

    static let identifier = "SystemChatTableViewCell"
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.tintColor = .label
        imageView.image = UIImage(named: "geminiLogo")
        return imageView
    }()
    
    private lazy var messageBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        view.layer.cornerRadius = 17
        return view
    }()
    
    public lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
   
    
    private func configureView() {
        contentView.addSubviews(profileImageView, messageBackgroundView)
        messageBackgroundView.addSubview(messageLabel)
        selectionStyle = .none
        
        messageBackgroundView.backgroundColor = UIColor.secondarySystemBackground
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            
            messageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageBackgroundView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            messageBackgroundView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
            messageBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            messageLabel.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: -10),
            messageLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -10)
        ])
    }
    
    public func configure(with text: ChatMessage) {
        let markdownText = SwiftyMarkdown(string: text.message)
        messageLabel.attributedText = markdownText.attributedString()
    }
}
