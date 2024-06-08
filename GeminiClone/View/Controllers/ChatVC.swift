//
//  ViewController.swift
//  GeminiClone
//
//  Created by Altan on 7.05.2024.
//

import UIKit

class ChatVC: UIViewController {
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 25
        textView.backgroundColor = .secondarySystemBackground
        textView.textContainerInset = UIEdgeInsets(top: 19, left: 10, bottom: 0, right: 110)
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return textView
    }()
    
    private lazy var placeHolder: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Buraya bir istem girin"
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatVCTableViewCell.self, forCellReuseIdentifier: ChatVCTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var sentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return button
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return button
    }()
    
    private lazy var photoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [photoButton, cameraButton, sentButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        return stackView
    }()
    
    var textViewHeightConstraint: NSLayoutConstraint!
    let welcomeView = WelcomeView()
    
    private var models = [ChatMessage]()
    
    private var viewModel: ChatViewModel
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        welcomeView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureConstraints()
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.bringSubviewToFront(textView)
        view.bringSubviewToFront(buttonsStackView)
    }
    
    private func configureView() {
        title = "Gemini"
        view.backgroundColor = .systemBackground
        view.addSubviews(textView, tableView, welcomeView, buttonsStackView)
        textView.addSubviews(placeHolder)
        
        let listButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, target: self, action: nil)
        listButton.tintColor = .label
        
        navigationItem.leftBarButtonItem = listButton
        
        sentButton.addTarget(self, action: #selector(didTapSentButton), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(didTapPhotoButton), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(didTapSentCameraButton), for: .touchUpInside)
        
    }

    private func configureConstraints() {
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 55)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
            textViewHeightConstraint,
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            
            placeHolder.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            placeHolder.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 15),
            placeHolder.widthAnchor.constraint(equalToConstant: 170),
            
            buttonsStackView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -15),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 100),
            
            welcomeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            welcomeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            welcomeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            welcomeView.bottomAnchor.constraint(equalTo: textView.topAnchor)
        ])
    }
    
    @objc
    private func didTapSentButton() {
        guard let text = textView.text, !text.isEmpty else { return }
        welcomeView.isHidden = !text.isEmpty
        textView.resignFirstResponder()
        textView.text = nil
        
        // recall function to update placeholder visibility
        textViewDidChange(textView)
        
        viewModel.sendMessage(text)
    }
    
    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.scrollToRow()
        }
    }
    
    private func scrollToRow() {
        let newIndexPath = IndexPath(row: self.models.count - 1, section: 0)
        tableView.scrollToRow(at: newIndexPath, at: .top, animated: true)
    }
    
    @objc
    private func didTapPhotoButton() {
        print("tapped")
    }
    
    @objc
    private func didTapSentCameraButton() {
        print("tapped")
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func adjustTextFieldHeight() {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = calculateTextViewHeight(from: newSize)
        textViewHeightConstraint.constant = newHeight
        view.layoutIfNeeded()
    }
    
    private func calculateTextViewHeight(from size: CGSize) -> CGFloat {
        let maxHeight: CGFloat = 150
        if size.height >= maxHeight {
            textView.isScrollEnabled = true
            return maxHeight
        } else {
            textView.isScrollEnabled = false
            return size.height + 17
        }
    }
}

extension ChatVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeHolder.isHidden = !textView.text.isEmpty
        adjustTextFieldHeight()
        view.layoutIfNeeded()
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatVCTableViewCell.identifier, for: indexPath) as? ChatVCTableViewCell else { return UITableViewCell() }
        let model = models[indexPath.row]
        
        if model.participant == .system {
            cell.backgroundColor = .secondarySystemFill
        } else {
            cell.backgroundColor = .systemBackground
        }
        
        if model.pending && model.participant == .system {
            cell.configure(ChatMessage(message: "Analiz ediliyor...", participant: .system))
            cell.messageLabel.startShimmering()
        } else {
            cell.configure(models[indexPath.row])
            cell.messageLabel.stopShimmering()
        }
        
        return cell
    }
}

extension ChatVC: ChatViewModelDelegate {
    func getMessage(_ message: ChatMessage) {
        self.models.append(message)
        reloadData()
    }
    
    func updateLastMessage(_ message: ChatMessage) {
        guard !self.models.isEmpty else { return }
        self.models[self.models.count - 1] = message
        reloadData()
    }
}

extension ChatVC: WelcomeViewDelegate {
    func getSelectedPrompt(_ prompt: ChatMessage) {
        welcomeView.isHidden = true
        reloadData()
        viewModel.sendMessage(prompt.message)
    }
}

