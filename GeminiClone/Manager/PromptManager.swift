//
//  PromptManager.swift
//  GeminiClone
//
//  Created by Altan on 24.05.2024.
//

import Foundation

class PromptManager {
    static let shared = PromptManager()
    
    init() {}
    
    private let prompts: [Prompt] = [
        Prompt(title: "Teknolojik gelişmeler", image: "safari"),
        Prompt(title: "Ürün ismi fikirleri", image: "lightbulb.circle"),
        Prompt(title: "Gezi rotası oluştur", image: "pencil.and.outline"),
        Prompt(title: "Ekonomi kavramları", image: "lightbulb.circle")
    ]
    
    func getPrompts(at index: Int) -> Prompt {
        return prompts[index]
    }
    
    func getPromptCount() -> Int {
        return prompts.count
    }
}
