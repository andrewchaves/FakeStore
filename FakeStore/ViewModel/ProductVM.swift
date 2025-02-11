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
}

class ProductVM {
    
    @Published var products: [ProductForUI] = []
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
                            self?.errorMessage = "Error while loading products: \(error.localizedDescription)"
                        }
                    }, receiveValue: { [weak self] products in
                        self?.products = products.map { product in
                            ProductForUI(
                                id: product.id,
                                title: product.title,
                                price: "$\(product.price)",
                                description: product.description,
                                image: product.image
                            )
                        }
                    })
                    .store(in: &cancellables)
            } catch {
                self.errorMessage = APIError.networkError(error).localizedDescription
            }
        }
    }
}
