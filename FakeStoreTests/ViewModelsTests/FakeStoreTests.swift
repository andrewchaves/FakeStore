//
//  FakeStoreTests.swift
//  FakeStoreTests
//
//  Created by Andrew Vale on 28/01/25.
//

import XCTest
@testable import FakeStore

final class ProductVMTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProductInitialization() throws {
        let mockProduct = ProductForUI(
            id: 1,
            title: "T-shirt",
            price: "$69.99",
            description: "A good product.",
            image: "https://exemplo.com/camiseta.png",
            category: "Clothes"
        )
        
        let viewModel = ProductVM()
        viewModel.products = [mockProduct]
        XCTAssertEqual(viewModel.products[0].title, "T-shirt")
    }
    
    func testProductPriceConvertion() throws {
        let mockProduct = ProductForUI(
            id: 1,
            title: "T-shirt",
            price: "$69.99",
            description: "A good product.",
            image: "https://exemplo.com/camiseta.png",
            category: "Clothes"
        )
        
        let viewModel = ProductVM()
        viewModel.products = [mockProduct]
        
        let product: Product = viewModel.products[0].toProduct()
        XCTAssertEqual(product.price, 69.99)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
