//
//  CartItemVM.swift
//  FakeStore
//
//  Created by Andrew Vale on 20/02/25.
//

import Foundation
import Combine

protocol CartItemViewModelProtocol: ObservableObject {
    var cartItems: [CartItem] { get }
    func addProduct(_ product: ProductForUI)
    func removeCartItem(id: UUID)
    func updateCartItemQuantity(for id: Int64, newQuantity: Int)
}

class CartItemVM: CartItemViewModelProtocol {
    @Published var cartItems: [CartItem] = []
    
    private let cartItemRepository: any CartItemRepositoryProtocol
    
    init (cartItemRepository: CartItemRepositoryProtocol) {
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
