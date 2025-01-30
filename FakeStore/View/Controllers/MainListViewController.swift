//
//  ViewController.swift
//  FakeStore
//
//  Created by Andrew Vale on 28/01/25.
//

import UIKit

class MainListViewController: UIViewController {
    
    var products: [Product]?
    let service: Service = Service()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        Task {
            do {
                products = try await service.makeRequest(endPoint: "/products", method: .GET, reponseType: [Product].self)
                print(products ?? [])
            } catch let error as APIError {
                throw APIError.networkError(error)
            } catch {
                print("misterious error")
            }
        }
    }


}

