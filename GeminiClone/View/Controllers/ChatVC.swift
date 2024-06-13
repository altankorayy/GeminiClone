//
//  ViewController.swift
//  GeminiClone
//
//  Created by Altan on 7.05.2024.
//

import UIKit
import PhotosUI

class ChatVC: UIViewController {
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 25
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.secondarySystemFill.cgColor
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
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
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
    
    private var newChatButton: UIBarButtonItem?
    private var textViewHeightConstraint: NSLayoutConstraint!
    private var messages = [ChatMessage]()
    private var viewModel: ChatViewModel
    private var welcomeView = WelcomeView()
    
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
        welcomeView.alpha = 1
        
        configureNavigation()
        configureNavigationBarButtons()
        configureButtons()
        configureGesture()
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
    
    private func configureNavigationBarButtons() {
        let listButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, target: self, action: nil)
        listButton.tintColor = .label
        
        newChatButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(didTapNewChatButton))
        newChatButton?.tintColor = .label
        newChatButton?.isHidden = true
        
        navigationItem.leftBarButtonItem = listButton
        navigationItem.rightBarButtonItem = newChatButton
    }
    
    private func configureButtons() {
        sentButton.addTarget(self, action: #selector(didTapSentButton), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(didTapPhotoButton), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(didTapCameraButton), for: .touchUpInside)
    }
    
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    private func configureNavigation() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func didTapSentButton() {
        guard let text = textView.text, !text.isEmpty else { return }
        showWelcomeView(!text.isEmpty)
        textView.resignFirstResponder()
        textView.text = nil
        
        // recall function to update placeholder visibility
        textViewDidChange(textView)
        
        viewModel.sendMessage(text)
        newChatButton?.isHidden = false
    }
    
    @objc
    private func didTapNewChatButton() {
        newChatButton?.isHidden = true
        showWelcomeView(false)
        messages.removeAll()
        tableView.reloadData()
    }
    
    @objc
    private func didTapPhotoButton() {
        guard !textView.text.isEmpty else {
            showAlert(title: "Error", message: "Please enter a prompt before selecting image.")
            return
        }
        
        var pickerConfiguration = PHPickerConfiguration()
        pickerConfiguration.selectionLimit = 1
        pickerConfiguration.filter = .images
        let picker = PHPickerViewController(configuration: pickerConfiguration)
        picker.isEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc
    private func didTapCameraButton() {
        print("Camera button tapped.")
    }
    
    private func showWelcomeView(_ show: Bool) {
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self else { return }
            self.welcomeView.alpha = show ? 0 : 1
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
            self.scrollToRow()
        }
    }
    
    private func scrollToRow() {
        let newIndexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: newIndexPath, at: .top, animated: true)
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

// MARK: - UITextView
extension ChatVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeHolder.isHidden = !textView.text.isEmpty
        adjustTextFieldHeight()
        view.layoutIfNeeded()
    }
}

// MARK: - UITableView
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatVCTableViewCell.identifier, for: indexPath) as? ChatVCTableViewCell else { return UITableViewCell() }
        let model = messages[indexPath.row]
        
        if model.pending && model.participant == .system {
            cell.configure(ChatMessage(message: "Analiz ediliyor...", participant: .system))
            cell.messageLabel.startShimmering()
        } else {
            cell.configure(model)
            cell.messageLabel.stopShimmering()
        }
        
        return cell
    }
}

// MARK: - ChatViewModelDelegate
extension ChatVC: ChatViewModelDelegate {
    func getMessage(_ message: ChatMessage) {
        messages.append(message)
        reloadData()
    }
    
    func updateLastMessage(_ message: ChatMessage) {
        guard !messages.isEmpty else { return }
        messages[messages.count - 1] = message
        reloadData()
    }
}

// MARK: - WelcomeViewDelegate
extension ChatVC: WelcomeViewDelegate {
    func getSelectedPrompt(_ prompt: ChatMessage) {
        showWelcomeView(true)
        reloadData()
        viewModel.sendMessage(prompt.message)
        newChatButton?.isHidden = false
    }
}

// MARK: - PHPickerViewController
extension ChatVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider else { return }
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self else { return }
                
                guard let image = image, error == nil else {
                    print("Failed to get image.")
                    return
                }
                
                DispatchQueue.main.async {
                    guard let selectedImage = image as? UIImage else { return }
                    self.showWelcomeView(!self.textView.text.isEmpty)
                    self.viewModel.sendMessage(self.textView.text, image: selectedImage)
                    self.textView.resignFirstResponder()
                    self.textView.text = nil
                    self.newChatButton?.isHidden = false
                    self.textViewDidChange(self.textView)
                }
            }
        }
    }
}

extension ChatVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: welcomeView.collectionView) {
            return false
        }
        return true
    }
}
