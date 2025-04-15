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
    
    func updateQuantity(for id:UUID, to newQuantity: Int) {
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let items = try context.fetch(fetchRequest)
            if let itemToBeUpdated = items.first {
                itemToBeUpdated.quantity = Int16(newQuantity)
                try context.save()
            } else {
                print("ID not found!")
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
