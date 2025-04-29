//
//  CartItemRepository.swift
//  FakeStore
//
//  Created by Andrew Vale on 17/02/25.
//

import CoreData

protocol CartItemRepositoryProtocol {
    func addProduct(id: Int64, name: String, quantity: Int16, price: Double, image: String)
    func fetchCartItems() -> [CartItem]
    func removeProduct(id: UUID)
    func updateQuantity(for id:Int64, isUp: Bool) 
}

class CartItemRepository: CartItemRepositoryProtocol {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func addProduct(id: Int64, name: String, quantity: Int16, price: Double, image: String) {
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
    
    func fetchCartItems() -> [CartItem]{
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            //TODO: - Improve error handling
            print(error)
            return []
        }
    }
    
    func removeProduct(id: UUID) {
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let cartItems = try context.fetch(fetchRequest)
            if let itemToRemove = cartItems.first {
                context.delete(itemToRemove)
                try context.save()
            }
        } catch {
            print(error)
            //TODO: - Improve error handling
        }
    }
    
    func updateQuantity(for id:Int64, isUp: Bool) {
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", id as CVarArg)
        
        do {
            let items = try context.fetch(fetchRequest)
            if let itemToBeUpdated = items.first {
                if (isUp){
                    itemToBeUpdated.price = (itemToBeUpdated.price / Double(itemToBeUpdated.quantity))  * Double(itemToBeUpdated.quantity + 1)
                    itemToBeUpdated.quantity = itemToBeUpdated.quantity + 1
                } else if (itemToBeUpdated.quantity > 1) {
                    itemToBeUpdated.price = (itemToBeUpdated.price / Double(itemToBeUpdated.quantity))  * Double(itemToBeUpdated.quantity - 1)
                    itemToBeUpdated.quantity = itemToBeUpdated.quantity - 1
                }
                try context.save()
            } else {
                print("ID not found!")
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
