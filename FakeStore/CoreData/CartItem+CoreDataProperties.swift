//
//  CartItem+CoreDataProperties.swift
//  FakeStore
//
//  Created by Andrew Vale on 17/02/25.
//
//

import Foundation
import CoreData


extension CartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var quantity: Int16
    @NSManaged public var image: String?

}

extension CartItem : Identifiable {

}
