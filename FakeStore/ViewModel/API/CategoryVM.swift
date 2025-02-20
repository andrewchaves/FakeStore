//
//  CategoryVM.swift
//  FakeStore
//
//  Created by Andrew Vale on 12/02/25.
//

import Foundation
import Combine

class CategorytVM {
    
    @Published var categories: [Category] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let service = Service()
    
    func fetchCategories() {
        isLoading = true
        Task {
            do {
                try await service.makeRequest(endPoint: .categories, method: .GET, reponseType: [String].self)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        self?.isLoading = false
                        if case let .failure(error) = completion {
                            self?.errorMessage = APIError.networkError(error).localizedDescription
                        }
                    }, receiveValue: { [weak self] categories in
                        self?.categories = categories.map {
                            Category(
                                name: $0
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
