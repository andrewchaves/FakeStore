//
//  CartListViewController.swift
//  FakeStore
//
//  Created by Andrew Vale on 02/04/25.
//

import UIKit


class CartListViewController: UIViewController {
    var tableView = UITableView()
    var coreDataManager: CoreDataManager
    var cartItemRepository: CartItemRepository
    var cartItemVM: CartItemVM
    
    init () {
        coreDataManager = CoreDataManager(modelName: "FakeStore")
        cartItemRepository  = CartItemRepository(coreDataManager: coreDataManager)
        cartItemVM  = CartItemVM(cartItemRepository: cartItemRepository)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cart"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartItemTableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupView()
        fetchItems()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor),
        ])
    }
    
    func fetchItems() {
        cartItemVM.fetchCartItems()
    }
}

//MARK: - Tableview Methods
extension CartListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItemVM.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CartItemTableViewCell else {
            return UITableViewCell()
        }
        
        //TODO: - refactor to pass CartItem
        cell.fill(id: cartItemVM.cartItems[indexPath.row].id,
                  image: cartItemVM.cartItems[indexPath.row].image ?? "",
                  title: cartItemVM.cartItems[indexPath.row].name ?? "",
                  price: String(cartItemVM.cartItems[indexPath.row].price))
        return cell
    }
    
    
}
