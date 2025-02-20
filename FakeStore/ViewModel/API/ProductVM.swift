//
//  ProductVM.swift
//  FakeStore
//
//  Created by Andrew Vale on 30/01/25.
//

import Foundation
import Combine

struct ProductForUI {
    var id: Int
    var title: String
    var price: String
    var description: String
    var image: String
    var category: String
    
    func toProduct() -> Product{
        
        return Product(id: self.id,
                       title: self.title,
                       price: 0.0, //TODO: - Convert the real price
                       description: self.description,
                       image: self.image,
                       category: self.category)
    }
}

class ProductVM {
    
    @Published var products: [ProductForUI] = []
    @Published var filteredProducts: [ProductForUI] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let service = Service()
    
    func fetchProducts() {
        isLoading = true
        Task {
            do {
                try await service.makeRequest(endPoint: .products, method: .GET, reponseType: [Product].self)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        self?.isLoading = false
                        if case let .failure(error) = completion {
                            self?.errorMessage = APIError.networkError(error).localizedDescription
                        }
                    }, receiveValue: { [weak self] products in

                        self?.products = products.map { product in
                            ProductForUI(
                                id: product.id,
                                title: product.title,
                                price: "$\(product.price)",
                                description: product.description,
                                image: product.image,
                                category: product.category
                            )
                        }
                    })
                    .store(in: &cancellables)
                
                DispatchQueue.main.async {
                    self.filteredProducts = self.products
                    self.isLoading = false
                }
                        
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = APIError.networkError(error).localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func filterProducts(category: String?) {
        DispatchQueue.main.async {
            if let category = category {
                self.filteredProducts = self.products.filter {$0.category == category}
            } else {
                self.filteredProducts = self.products
            }
        }
    }
}
