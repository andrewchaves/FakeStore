//
//  CartListViewController.swift
//  FakeStore
//
//  Created by Andrew Vale on 02/04/25.
//

import UIKit


class CartListViewController: UIViewController {
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cart"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
    }
}

extension CartListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
