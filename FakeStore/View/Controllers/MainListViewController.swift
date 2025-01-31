//
//  ViewController.swift
//  FakeStore
//
//  Created by Andrew Vale on 28/01/25.
//

import UIKit
import Combine

class MainListViewController: UIViewController {
    
    var products: [Product]?
    let service: Service = Service()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        Task {

            do {
                let publisher: AnyPublisher<[Product], APIError> = try await service.makeRequest(endPoint: "/products", method: .GET, reponseType: [Product].self)
                
                publisher
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        if case let .failure(_) = completion {
                            print("Error")
                        }
                    }, receiveValue: { [weak self] products in
                        print(products)
                    })
                    .store(in: &cancellables)
            } catch {
                
            }
        }
    }


}

