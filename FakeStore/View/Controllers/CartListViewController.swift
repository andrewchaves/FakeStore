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
    
    var tableView = UITableView()
    var cartItemViewModel: any CartItemViewModelProtocol
    
    var finishBuyingButton: GeneralButton = {
        var button = GeneralButton(title: "Finish Buying",
                                   titleBold: true,
                                   titleTextColor: .white,
                                   backgroundColor: .buttonOrange)
        return button
    }()
    
    var summaryView: UIView = {
        var view = UIView()
        view.backgroundColor = .viewBlue
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    var totalPrice: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .light)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    
    init (cartItemViewModel: any CartItemViewModelProtocol = AppContainer.shared.cartItemViewModel) {
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
    
    func observeCartItems() {
        cartItemViewModel.cartItemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                if let totalPrice = self?.cartItemViewModel.getPriceSum() {
                    self?.totalPrice.text = "$\(totalPrice)"
                }
            }
            .store(in: &cancellables)
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        self.view.addSubview(summaryView)
        summaryView.addSubview(totalPrice)
        self.view.addSubview(finishBuyingButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        
        totalPrice.translatesAutoresizingMaskIntoConstraints = false
        
        finishBuyingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.summaryView.topAnchor, constant: -8.0),
            
            summaryView.heightAnchor.constraint(equalToConstant: 120.0),
            summaryView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            summaryView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            summaryView.bottomAnchor.constraint(equalTo: self.finishBuyingButton.topAnchor, constant: -24.0),
            
            totalPrice.topAnchor.constraint(equalTo: summaryView.topAnchor, constant: 8.0),
            totalPrice.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: 8.0),

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
