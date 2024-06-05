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
}

class ChatViewModel {
    
    weak var delegate: ChatViewModelDelegate?
    private let model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: APIKey.default)
    
    func sendMessage(_ text: String) {
        Task {
            do {
                let response = try await model.generateContent(text)
                guard let textResponse = response.text else { return }
                print(textResponse)
                let chatMessage = ChatMessage(message: textResponse, participant: .system)
                delegate?.getMessage(chatMessage)
            } catch {
                delegate?.getMessage(ChatMessage(message: error.localizedDescription, participant: .system))
            }
        }
    }
}
