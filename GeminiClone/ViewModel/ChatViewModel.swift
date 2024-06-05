//
//  ChatViewModel.swift
//  GeminiClone
//
//  Created by Altan on 4.06.2024.
//

import Foundation
import GoogleGenerativeAI

protocol ChatViewModelDelegate: AnyObject {
    func getMessage(_ message: ChatMessage)
    func updateLastMessage(_ message: ChatMessage)
}

class ChatViewModel {
    
    weak var delegate: ChatViewModelDelegate?
    private let model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: APIKey.default)
    
    func sendMessage(_ text: String) {
        let userMessage = ChatMessage(message: text, participant: .user)
        delegate?.getMessage(userMessage)
        
        let pendingMessage = ChatMessage(message: "", participant: .system, pending: true)
        delegate?.getMessage(pendingMessage)
        Task {
            do {
                let response = try await model.generateContent(text)
                guard let textResponse = response.text else { return }
                delegate?.updateLastMessage(ChatMessage(message: textResponse, participant: .system))
            } catch {
                delegate?.updateLastMessage(ChatMessage(message: error.localizedDescription, participant: .system))
            }
        }
    }
}
