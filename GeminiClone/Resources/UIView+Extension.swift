//
//  UIView+Extension.swift
//  GeminiClone
//
//  Created by Altan on 24.05.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
