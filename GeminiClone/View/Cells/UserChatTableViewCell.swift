//
//  UserChatTableViewCell.swift
//  GeminiClone
//
//  Created by Altan on 15.06.2024.
//

import UIKit
import SwiftyMarkdown

class UserChatTableViewCell: UITableViewCell {

    static let identifier = "UserChatTableViewCell"
    
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
        label.textAlignment = .right
        return label
    }()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientImage = UIImage.gradientImage(bounds: messageBackgroundView.bounds, colors: [.systemBlue, .blue])
        messageBackgroundView.backgroundColor = UIColor(patternImage: gradientImage)
        
        messageLabel.textColor = .white
    }
    
    private func configureView() {
        selectionStyle = .none
        contentView.addSubviews(messageBackgroundView, contentImageView)
        messageBackgroundView.addSubview(messageLabel)
    }
    
    private func configureConstraints() {
        contentImageViewHeightConstraint = contentImageView.heightAnchor.constraint(equalToConstant: 200)
        NSLayoutConstraint.activate([
            contentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            contentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentImageView.widthAnchor.constraint(equalToConstant: 300),
            contentImageViewHeightConstraint,
            
            messageBackgroundView.topAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: 10),
            messageBackgroundView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 48),
            messageBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
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
        
        HapticsManager.shared.vibrate()
        
        if let image = text.image {
            contentImageView.image = image
            contentImageView.isHidden = false
            contentImageViewHeightConstraint.constant = 200
        } else {
            contentImageView.isHidden = true
            contentImageViewHeightConstraint.constant = 0
        }
    }
}
