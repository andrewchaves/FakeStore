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
    
    var finishBuyingButton: GeneralButton = {
        var button = GeneralButton(title: "Finish Buying",
                                   titleBold: true,
                                   titleTextColor: .white,
                                   backgroundColor: .orange)
        return button
    }()
    
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
        self.view.addSubview(finishBuyingButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        
        finishBuyingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo:self.finishBuyingButton.topAnchor, constant: -8.0),
            

            finishBuyingButton.heightAnchor.constraint(equalToConstant: 60.0),
            finishBuyingButton.leadingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            finishBuyingButton.trailingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            finishBuyingButton.bottomAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.bottomAnchor),
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
        
        cell.fill(cartItem: cartItemVM.cartItems[indexPath.row])
        return cell
    }
    
    
}
