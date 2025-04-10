//
//  CartItemTableViewCell.swift
//  FakeStore
//
//  Created by Andrew Vale on 02/04/25.
//

import Foundation
import UIKit

class CartItemTableViewCell: ProductTableViewCell {
    
    var quantityDown: GeneralButton = {
        var button = GeneralButton(title: "-",
                                   titleBold: true,
                                   titleTextColor: .white,
                                   backgroundColor: .blue)
        return button
    }()
    
    var quantityUP: GeneralButton = {
        var button = GeneralButton(title: "+",
                                   titleBold: true,
                                   titleTextColor: .white,
                                   backgroundColor: .blue)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    //MARK: - Cell Configuration
    override func setupView() {
        super.setupView()
        quantityDown.translatesAutoresizingMaskIntoConstraints = false
        quantityUP.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(quantityDown)
        self.contentView.addSubview(quantityUP)

        NSLayoutConstraint.activate([
            //Up Button
            quantityUP.widthAnchor.constraint(equalToConstant: 12.0),
            quantityUP.heightAnchor.constraint(equalToConstant: 12.0),
            quantityUP.trailingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: -8.0),
            quantityUP.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0),
            
            //Down Button
            quantityUP.widthAnchor.constraint(equalToConstant: 12.0),
            quantityUP.heightAnchor.constraint(equalToConstant: 12.0),
            quantityUP.trailingAnchor.constraint(equalTo: self.quantityUP.leadingAnchor, constant: -8.0),
            quantityUP.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0),
        ])
    }
    
    override func fill(image:String,
              title: String,
              price: String) {
        super.fill(image: image, title: title, price: price)
    }
}
