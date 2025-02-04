//
//  ViewController.swift
//  FakeStore
//
//  Created by Andrew Vale on 28/01/25.
//

import UIKit
import Combine

class MainListViewController: UIViewController {
    
    private var productVM = ProductVM()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        bindViewModel()
        productVM.fetchProducts()
    }

    private func bindViewModel() {
        productVM.$products
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                print(self?.productVM.products)
            })
            .store(in: &cancellables)
    }

}

