//
//  CoreDataManager.swift
//  FakeStore
//
//  Created by Andrew Vale on 17/02/25.
//

import CoreData

class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
        persistentContainer.loadPersistentStores {_, error in
            if let error = error {
                //TODO: - Implement a better error handling
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                //TODO: - Implement a better error handling
                print("Error while saving context \(error)")
            }
        }
    }
}
