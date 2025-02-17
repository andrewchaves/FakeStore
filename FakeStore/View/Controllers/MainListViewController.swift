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
    
    var filterButton: UIBarButtonItem = {
        var barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(systemName: "line.3.horizontal.decrease")
        barButtonItem.menu = nil
        barButtonItem.tintColor = .black
        return barButtonItem
    }()
    
    var cartButton: UIBarButtonItem = {
        var barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(systemName: "cart")
        barButtonItem.menu = nil
        barButtonItem.tintColor = .black
        return barButtonItem
    }()
    
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
        navigationItem.rightBarButtonItems = [filterButton, cartButton]
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
        
        let showAllProductsAction = UIAction(title: "All products") { _ in
            self.productVM.filterProducts(category: nil)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        children.append(showAllProductsAction)
        
        categoryVM.categories.forEach({ category in
            let action = UIAction(title: category.name) { _ in
                self.productVM.filterProducts(category: category.name)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            children.append(action)
        })
    
        navigationItem.rightBarButtonItems?[0].menu = UIMenu(title: "Select a category", children: children)
    }
    
    //MARK: - Bindings
    private func bindViewModel() {
        productVM.$products
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
            .store(in: &cancellables)
        
        categoryVM.$categories
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.createContextMenu()
            })
            .store(in: &cancellables)
    }
}

// MARK: - Tableview methods
extension MainListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productVM.filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        
        cell.fill(image: productVM.filteredProducts[indexPath.row].image,
                  title: productVM.filteredProducts[indexPath.row].title,
                  price: productVM.filteredProducts[indexPath.row].price)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailsVC = ProductDetailsViewController(productToDisplay: productVM.filteredProducts[indexPath.row])
        productDetailsVC.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.pushViewController(productDetailsVC, animated: true)
    }
}

