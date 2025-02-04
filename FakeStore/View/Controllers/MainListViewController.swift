//
//  ViewController.swift
//  FakeStore
//
//  Created by Andrew Vale on 28/01/25.
//

import UIKit
import Combine

class MainListViewController: UIViewController {
    var tableView = UITableView()
    private var productVM = ProductVM()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        bindViewModel()
        productVM.fetchProducts()
        bluidScreen()
    }
    
    private func bindViewModel() {
        productVM.$products
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    func bluidScreen() {
        
        self.view.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate(
            [tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
             tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
             tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
}

// MARK: - Tableview methods
extension MainListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productVM.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UITableViewCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = productVM.products[indexPath.row].title
        return cell
    }
}

