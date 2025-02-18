//
//  CartItemRepository.swift
//  FakeStore
//
//  Created by Andrew Vale on 17/02/25.
//

import CoreData

class CartItemRepository {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func addProduct(id: UUID, name: String, quantity: Int16, price: Double, image: String) {
        let backgroundContext = coreDataManager.backgroundContext
        
        backgroundContext.perform {
            let newCartItem = CartItem(context: backgroundContext)
            newCartItem.id = id
            newCartItem.name = name
            newCartItem.quantity = quantity
            newCartItem.price = price
            newCartItem.image = image
            
            do {
                try backgroundContext.save()
            } catch {
                print("Error saving the \(newCartItem.name ?? "") to cart")
            }
        }
    }
}
