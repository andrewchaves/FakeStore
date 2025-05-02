//
//  AppContainer.swift
//  FakeStore
//
//  Created by Andrew Vale on 24/04/25.
//

import Foundation

final class AppContainer {
    static let shared = AppContainer()
    
    var coreDataManager: CoreDataManager
    var cartItemRepository: CartItemRepository
    
    private init() {
        self.coreDataManager = CoreDataManager(modelName: "FakeStore")
        self.cartItemRepository = CartItemRepository(coreDataManager: coreDataManager)
    }
}
