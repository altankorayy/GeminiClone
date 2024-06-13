//
//  ChatViewModel.swift
//  GeminiClone
//
//  Created by Altan on 4.06.2024.
//

import UIKit
import GoogleGenerativeAI

protocol ChatViewModelDelegate: AnyObject {
    func getMessage(with message: ChatMessage)
    func updateLastMessage(with message: ChatMessage)
}

class ChatViewModel {
    
    weak var delegate: ChatViewModelDelegate?
    private let model = GenerativeModel(name: "gemini-1.5-pro", apiKey: APIKey.default)
    
    func sendMessage(with text: String, image: UIImage? = nil) {
        handleUserMessage(text: text, image: image)
        handlePendingMessage()
        
        Task {
            do {
                let response: GenerateContentResponse
                if let image = image {
                    response = try await model.generateContent(text, image)
                } else {
                    response = try await model.generateContent(text)
                }
                
                guard let textResponse = response.text else { return }
                delegate?.updateLastMessage(with: ChatMessage(message: textResponse, participant: .system))
            } catch {
                delegate?.updateLastMessage(with: ChatMessage(message: error.localizedDescription, participant: .system))
            }
        }
    }
    
    private func handleUserMessage(text: String, image: UIImage?) {
        let userMessage = ChatMessage(message: text, image: image, participant: .user)
        delegate?.getMessage(with: userMessage)
    }
    
    private func handlePendingMessage() {
        let pendingMessage = ChatMessage(message: "", participant: .system, pending: true)
        delegate?.getMessage(with: pendingMessage)
    }
}
