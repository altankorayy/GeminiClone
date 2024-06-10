//
//  AlertVC.swift
//  GeminiClone
//
//  Created by Altan on 10.06.2024.
//

import UIKit

final class AlertVC: UIViewController {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let containerView = AlertContainerView()

    var alertTitle: String
    var message: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureConstraints()
    }
    
    init(alertTitle: String, message: String) {
        self.alertTitle = alertTitle
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureView() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, messageLabel, closeButton)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
        titleLabel.text = alertTitle
        messageLabel.text = message
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8),
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -6),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc
    private func didTapCloseButton() {
        dismiss(animated: true)
    }
}
