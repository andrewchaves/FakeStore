//
//  CartItemTableViewCell.swift
//  FakeStore
//
//  Created by Andrew Vale on 02/04/25.
//

import Foundation
import UIKit

class CartItemTableViewCell: ProductTableViewCell {
    
    var coreDataManager: CoreDataManager
    var cartItemRepository: CartItemRepository
    var cartItemVM: CartItemVM
    
    var cartItemID: Int64?
    
    var quantityDownButton: GeneralButton = {
        var button = GeneralButton(title: "-",
                                   titleBold: true,
                                   titleTextColor: .white,
                                   backgroundColor: .blue)
        return button
    }()
    
    var quantityUPButton: GeneralButton = {
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
        coreDataManager = CoreDataManager(modelName: "FakeStore")
        cartItemRepository  = CartItemRepository(coreDataManager: coreDataManager)
        cartItemVM  = CartItemVM(cartItemRepository: cartItemRepository)
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

        self.contentView.addSubview(quantityDownButton)
        self.contentView.addSubview(quantityUPButton)

        NSLayoutConstraint.activate([
            //Up Button
            quantityUPButton.widthAnchor.constraint(equalToConstant: 20.0),
            quantityUPButton.heightAnchor.constraint(equalToConstant: 20.0),
            quantityUPButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8.0),
            quantityUPButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0),
            
            //Down Button
            quantityDownButton.widthAnchor.constraint(equalToConstant: 20.0),
            quantityDownButton.heightAnchor.constraint(equalToConstant: 20.0),
            quantityDownButton.trailingAnchor.constraint(equalTo: self.quantityUPButton.leadingAnchor, constant: -8.0),
            quantityDownButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0),
        ])
    }
    
    func fill(id: Int64, image:String,
              title: String,
              price: String) {
        super.fill(image: image, title: title, price: price)
        self.cartItemID = id
    }
    
    //MARK: - Actions
    @objc func quantityGoesUp() {
        //TODO: - Mock logic just to test it.
        if let id = cartItemID {
            cartItemVM.updateCartItemQuantity(for: id, newQuantity: Int.random(in: 0...10))
        }
    }
    
    @objc func quantityGoesDown() {
        //TODO: - Mock logic just to test it.
        if let id = cartItemID {
            cartItemVM.updateCartItemQuantity(for: id, newQuantity: Int.random(in: 0...10))
        }
    }
}
