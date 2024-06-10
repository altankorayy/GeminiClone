//
//  UIViewController+Extension.swift
//  GeminiClone
//
//  Created by Altan on 10.06.2024.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertVC = AlertVC(alertTitle: title, message: message)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
