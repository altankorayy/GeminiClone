//
//  ChatModel.swift
//  GeminiClone
//
//  Created by Altan on 4.06.2024.
//

import Foundation

enum Participant {
    case system
    case user
}

struct ChatMessage {
    var message: String
    let participant: Participant
    var pending = false
}
