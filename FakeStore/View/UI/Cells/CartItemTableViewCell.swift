//
//  CartItemTableViewCell.swift
//  FakeStore
//
//  Created by Andrew Vale on 02/04/25.
//

import Foundation
import UIKit

protocol CartItemTableViewCellDelegate: AnyObject {
    func upButtonTapped(_ cell: CartItemTableViewCell, id: Int64)
    func downButtonTapped(_ cell: CartItemTableViewCell, id: Int64)
}

class CartItemTableViewCell: ProductTableViewCell {
    
    weak var delegate: CartItemTableViewCellDelegate?
    
    var cartItemID: Int64?
    
    var quantityDownButton: GeneralButton = {
        var button = GeneralButton(title: "-",
                                   titleBold: true,
                                   titleTextColor: .white,
                                   backgroundColor: .buttonBlue)
        return button
    }()
    
    var quantityUPButton: GeneralButton = {
        var button = GeneralButton(title: "+",
                                   titleBold: true,
                                   titleTextColor: .white,
                                   backgroundColor: .buttonBlue)
        return button
    }()
    
    var productQuantity: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .light)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "1"
        return label
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
        quantityDownButton.addTarget(self, action: #selector(quantityGoesDown), for: .touchUpInside)
        quantityUPButton.addTarget(self, action: #selector(quantityGoesUp), for: .touchUpInside)
        quantityDownButton.translatesAutoresizingMaskIntoConstraints = false
        quantityUPButton.translatesAutoresizingMaskIntoConstraints = false
        
        productQuantity.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(quantityDownButton)
        self.contentView.addSubview(quantityUPButton)
        self.contentView.addSubview(productQuantity)
        
        NSLayoutConstraint.activate([
            //Up Button
            quantityUPButton.widthAnchor.constraint(equalToConstant: 20.0),
            quantityUPButton.heightAnchor.constraint(equalToConstant: 20.0),
            quantityUPButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8.0),
            quantityUPButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0),
            
            //Quantity
            productQuantity.widthAnchor.constraint(equalToConstant: 20.0),
            productQuantity.heightAnchor.constraint(equalToConstant: 20.0),
            productQuantity.trailingAnchor.constraint(equalTo: self.quantityUPButton.leadingAnchor, constant: -8.0),
            productQuantity.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0),
            
            //Down Button
            quantityDownButton.widthAnchor.constraint(equalToConstant: 20.0),
            quantityDownButton.heightAnchor.constraint(equalToConstant: 20.0),
            quantityDownButton.trailingAnchor.constraint(equalTo: self.productQuantity.leadingAnchor, constant: -8.0),
            quantityDownButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0),
        ])
    }
    
    func fill(cartItem: CartItem) {
        super.fill(image: cartItem.image ?? "",
                   title: cartItem.name ?? "",
                   price: String(format: "%.2f", cartItem.price))
        self.cartItemID = cartItem.id
        self.productQuantity.text = "\(cartItem.quantity)"
    }
    
    //MARK: - Actions
    @objc func quantityGoesUp() {
        if let id = cartItemID {
            delegate?.upButtonTapped(self, id: id)
        }
    }
    
    @objc func quantityGoesDown() {
        if let id = cartItemID {
            delegate?.downButtonTapped(self, id: id)
        }
    }
}
