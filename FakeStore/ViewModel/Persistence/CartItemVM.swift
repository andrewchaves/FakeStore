//
//  CartItemVM.swift
//  FakeStore
//
//  Created by Andrew Vale on 20/02/25.
//

import Foundation
import Combine

class CartItemVM: ObservableObject {
    @Published var cartItems: [CartItem] = []
    
    private let cartItemRepository: CartItemRepository
    
    init (cartItemRepository: CartItemRepository) {
        self.cartItemRepository = cartItemRepository
        fetchCartItems()
    }
    
    func fetchCartItems() {
        cartItems = cartItemRepository.fetchCartItems()
    }
    
    func addProduct(_ product: ProductForUI) {
        let product = product.toProduct()
        cartItemRepository.addProduct(id: Int64(product.id),
                                      name: product.title,
                                      quantity:  1,
                                      price: product.price,
                                      image: product.image)
        fetchCartItems()
    }
    
    func removeCartItem(id: UUID) {
        cartItemRepository.removeProduct(id: id)
        fetchCartItems()
    }
    
    func updateCartItemQuantity(for id: Int64, newQuantity: Int) {
        cartItemRepository.updateQuantity(for: id, to: newQuantity)
        fetchCartItems()
    }
}
