//
//  Product.swift
//  FakeStore
//
//  Created by Andrew Vale on 29/01/25.
//

import Foundation

struct Product: Codable {
    var id: Int
    var title: String
    var price: Double
    var description: String
    var image: String
    var category: String
}
