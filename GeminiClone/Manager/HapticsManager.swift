//
//  HapticsManager.swift
//  GeminiClone
//
//  Created by Altan on 15.06.2024.
//

import UIKit

class HapticsManager {
    static let shared = HapticsManager()
    
    init() {}
    
    public func vibrate() {
        DispatchQueue.main.async {
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.prepare()
            selectionFeedbackGenerator.selectionChanged()
        }
    }
}
