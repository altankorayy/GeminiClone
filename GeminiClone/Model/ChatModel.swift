//
//  ChatModel.swift
//  GeminiClone
//
//  Created by Altan on 4.06.2024.
//

import UIKit

enum Participant {
    case system
    case user
}

struct ChatMessage {
    var message: String
    var image: UIImage?
    let participant: Participant
    var pending = false
}
