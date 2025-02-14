//
//  GeneralButton.swift
//  FakeStore
//
//  Created by Andrew Vale on 14/02/25.
//

import Foundation
import UIKit

class GeneralButton: UIButton {
    
    init(title: String,
         titleBold: Bool,
         titleTextColor: UIColor,
         backgroundColor: UIColor) {
        
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleTextColor, for: .normal)
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 4
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18.0,
                                                  weight: titleBold ? .bold : .regular)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
