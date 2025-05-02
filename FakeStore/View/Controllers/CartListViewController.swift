//
//  CartListViewController.swift
//  FakeStore
//
//  Created by Andrew Vale on 02/04/25.
//

import UIKit
import Combine

class CartListViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    var tableView: UITableView = {
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    var cartItemViewModel: any CartItemViewModelProtocol
    
    var finishBuyingButton: GeneralButton = {
        var button = GeneralButton(title: "Finish Buying",
                                   titleBold: true,
                                   titleTextColor: .white,
                                   backgroundColor: .buttonOrange)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var summaryView: UIView = {
        var view = UIView()
        view.backgroundColor = .viewBlue
        view.layer.cornerRadius = 10.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var totalPriceTitle: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Total Price"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var totalPrice: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .light)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var totalQuantityTitle: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Total Quantity"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var totalQuantity: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .light)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init (cartItemViewModel: any CartItemViewModelProtocol = CartItemVM(cartItemRepository: AppContainer.shared.cartItemRepository)) {
        self.cartItemViewModel  = cartItemViewModel
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
        observeCartItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartItemViewModel.fetchCartItems()
    }
    
    func observeCartItems() {
        cartItemViewModel.cartItemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                if let totalQuantity = self?.cartItemViewModel.getQuantitySum() {
                    self?.totalQuantity.text = "\(totalQuantity)"
                }
                if let totalPrice = self?.cartItemViewModel.getPriceSum() {
                    self?.totalPrice.text = String(format: "$%.2f", totalPrice)
                }
            }
            .store(in: &cancellables)
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        self.view.addSubview(summaryView)
        summaryView.addSubview(totalQuantityTitle)
        summaryView.addSubview(totalQuantity)
        summaryView.addSubview(totalPriceTitle)
        summaryView.addSubview(totalPrice)
        self.view.addSubview(finishBuyingButton)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
             
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.summaryView.topAnchor, constant: -8.0),
            
            summaryView.heightAnchor.constraint(equalToConstant: 60.0),
            summaryView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            summaryView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            summaryView.bottomAnchor.constraint(equalTo: self.finishBuyingButton.topAnchor, constant: -24.0),
            
            totalQuantityTitle.topAnchor.constraint(equalTo: summaryView.topAnchor, constant: 8.0),
            totalQuantityTitle.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: 8.0),
            
            totalQuantity.topAnchor.constraint(equalTo: summaryView.topAnchor, constant: 8.0),
            totalQuantity.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -8.0),
            
            totalPriceTitle.topAnchor.constraint(equalTo: totalQuantityTitle.bottomAnchor, constant: 4.0),
            totalPriceTitle.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: 8.0),
            
            totalPrice.topAnchor.constraint(equalTo: totalQuantity.bottomAnchor, constant: 4.0),
            totalPrice.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -8.0),

            finishBuyingButton.heightAnchor.constraint(equalToConstant: 60.0),
            finishBuyingButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            finishBuyingButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            finishBuyingButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func fetchItems() {
        cartItemViewModel.fetchCartItems()
    }
}

//MARK: - TableView Methods
extension CartListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItemViewModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CartItemTableViewCell else {
            return UITableViewCell()
        }
        
        cell.fill(cartItem: cartItemViewModel.cartItems[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cartItemViewModel.removeCartItem(id: cartItemViewModel.cartItems[indexPath.row].id)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
}

//MARK: - TableViewCell Methods
extension CartListViewController: CartItemTableViewCellDelegate {
    func upButtonTapped(_ cell: CartItemTableViewCell, id: Int64) {
        self.cartItemViewModel.increaseCartItemQuantity(for: id)
    }
    
    func downButtonTapped(_ cell: CartItemTableViewCell, id: Int64) {
        self.cartItemViewModel.decreaseCartItemQuantity(for: id)
    }
}
