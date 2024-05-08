//
//  ChatVCTableViewCell.swift
//  GeminiClone
//
//  Created by Altan on 8.05.2024.
//

import UIKit

class ChatVCTableViewCell: UITableViewCell {

    static let identifier = "ChatVCTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureView() {
        selectionStyle = .none
    }

}
