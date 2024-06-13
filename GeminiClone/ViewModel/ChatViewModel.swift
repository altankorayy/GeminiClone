//
//  ChatViewModel.swift
//  GeminiClone
//
//  Created by Altan on 4.06.2024.
//

import UIKit
import GoogleGenerativeAI

protocol ChatViewModelDelegate: AnyObject {
    func getMessage(_ message: ChatMessage)
    func updateLastMessage(_ message: ChatMessage)
}

class ChatViewModel {
    
    weak var delegate: ChatViewModelDelegate?
    private let model = GenerativeModel(name: "gemini-1.5-pro", apiKey: APIKey.default)
    
    func sendMessage(_ text: String, image: UIImage? = nil) {
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
                delegate?.updateLastMessage(ChatMessage(message: textResponse, participant: .system))
            } catch {
                delegate?.updateLastMessage(ChatMessage(message: error.localizedDescription, participant: .system))
            }
        }
    }
    
    private func handleUserMessage(text: String, image: UIImage?) {
        let userMessage = ChatMessage(message: text, image: image, participant: .user)
        delegate?.getMessage(userMessage)
    }
    
    private func handlePendingMessage() {
        let pendingMessage = ChatMessage(message: "", participant: .system, pending: true)
        delegate?.getMessage(pendingMessage)
    }
}
