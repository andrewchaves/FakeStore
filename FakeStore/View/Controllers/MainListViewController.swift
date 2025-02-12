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
    private var categoryVM = CategorytVM()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Fake Store"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "cell")
        
        bindViewModel()
        productVM.fetchProducts()
        categoryVM.fetchCategories()
        setupNavigationBar()
        bluidScreen()
    }
    
    //MARK: - Setup
    func setupNavigationBar() {
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease"),
                                           menu: nil)
        filterButton.tintColor = .black
        navigationItem.rightBarButtonItem = filterButton
    }
    
    func bluidScreen() {
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        
        NSLayoutConstraint.activate(
            [tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
             tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
             tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
    }
    
    func createContextMenu() {
        var children:[UIAction] = []
        
        categoryVM.categories.forEach({ category in
            let action = UIAction(title: category.name) { _ in
                self.filterButtonTapped(category: category.name)
            }
            children.append(action)
        })
    
        navigationItem.rightBarButtonItem?.menu = UIMenu(title: "Select a category", children: children)
    }
    
    //MARK: - Bindings
    private func bindViewModel() {
        productVM.$products
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
        
        categoryVM.$categories
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.createContextMenu()
            })
            .store(in: &cancellables)
    }
    
    //MARK: - Actions
    @objc private func filterButtonTapped(category: String) {
        print("Category: \(category)")
    }
}

// MARK: - Tableview methods
extension MainListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productVM.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        
        cell.fill(image: productVM.products[indexPath.row].image,
                  title: productVM.products[indexPath.row].title,
                  price: productVM.products[indexPath.row].price)
        return cell
    }
}

