//
//  ProductDetailsViewController.swift
//  FakeStore
//
//  Created by Andrew Vale on 13/02/25.
//

import Foundation
import UIKit
import SDWebImage
import FakeStoreCore

class ProductDetailsViewController: UIViewController {
    
    var productToDisplay: ProductForUI
    var cartItemViewModel: any CartItemViewModelProtocol
    
    var cartButton: UIBarButtonItem = {
        var barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(systemName: "cart")
        barButtonItem.menu = nil
        barButtonItem.tintColor = .black
        return barButtonItem
    }()
    
    var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    var productView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 5.0
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var productTitle: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    var productPrice: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28.0)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    var productDescription: UITextView = {
        var text = UITextView()
        text.font = UIFont.systemFont(ofSize: 18.0)
        text.textColor = .lightGray
        text.isEditable = false
        text.isScrollEnabled = false
        return text
    }()
    
    var addToCartButton: GeneralButton = {
        var button = GeneralButton(title: "Add to Cart",
                                   titleBold: true,
                                   titleTextColor: .white,
                                   backgroundColor: .buttonGreen)
        return button
    }()
    
    var buyButton: GeneralButton = {
        var button = GeneralButton(title: "Buy it",
                                   titleBold: true,
                                   titleTextColor: .white,
                                   backgroundColor: .buttonBlue)
        return button
    }()
    
    init (productToDisplay: ProductForUI,
          cartItemViewModel: any CartItemViewModelProtocol) {
        self.productToDisplay = productToDisplay
        self.cartItemViewModel  = cartItemViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        bluidScreen()
        fillContent()
        
        addToCartButton.addTarget(self,
                         action: #selector(addProductToCart),
                         for: .touchUpInside)
    }
    
    //MARK: - Setup
    
    func setupNavigationBar() {
        cartButton.target = self
        cartButton.action = #selector(cartButtonTapped)
        navigationItem.rightBarButtonItems = [cartButton]
    }

    func bluidScreen() {
        let halfScreenWidth = self.view.frame.size.width/2
        let thirdScreenWidth = self.view.frame.size.width/3
        let productDescriptionHeight = productDescription.sizeThatFits(CGSize(width: self.view.frame.width - 32,
                                                                              height: CGFloat.greatestFiniteMagnitude)).height
        
        self.title = "Product Details"
        self.view.backgroundColor = .white
        
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        productView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productTitle.translatesAutoresizingMaskIntoConstraints = false
        productPrice.translatesAutoresizingMaskIntoConstraints = false
        productDescription.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(contentScrollView)
        contentScrollView.addSubview(productView)
        productView.addSubview(productImageView)
        contentScrollView.addSubview(productTitle)
        contentScrollView.addSubview(productPrice)
        contentScrollView.addSubview(productDescription)
        self.view.addSubview(addToCartButton)
        self.view.addSubview(buyButton)
        
        NSLayoutConstraint.activate(
            [contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 24),
             contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
             contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
             contentScrollView.bottomAnchor.constraint(equalTo: addToCartButton.topAnchor, constant: -16),
             
             productView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
             productView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
             productView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
             productView.heightAnchor.constraint(equalToConstant: 320),
             
             productImageView.topAnchor.constraint(equalTo: productView.topAnchor),
             productImageView.leadingAnchor.constraint(equalTo: productView.leadingAnchor),
             productImageView.trailingAnchor.constraint(equalTo: productView.trailingAnchor),
             productImageView.bottomAnchor.constraint(equalTo: productView.bottomAnchor),
             productImageView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
             
             productTitle.topAnchor.constraint(equalTo: productImageView.bottomAnchor,constant: 8),
             productTitle.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor, constant: 16),
             productTitle.widthAnchor.constraint(equalToConstant: halfScreenWidth),
             productTitle.heightAnchor.constraint(equalToConstant: 120),
             
             productPrice.topAnchor.constraint(equalTo: productImageView.bottomAnchor,constant: 8),
             productPrice.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor, constant: -16),
             productPrice.widthAnchor.constraint(equalToConstant: halfScreenWidth),
             
             productDescription.topAnchor.constraint(equalTo: productTitle.bottomAnchor,constant: 8),
             productDescription.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
             productDescription.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
             productDescription.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
             productDescription.heightAnchor.constraint(equalToConstant: productDescriptionHeight),
             
             addToCartButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -24),
             addToCartButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
             addToCartButton.widthAnchor.constraint(equalToConstant: thirdScreenWidth),
             addToCartButton.heightAnchor.constraint(equalToConstant: 60),
             
             buyButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -24),
             buyButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
             buyButton.widthAnchor.constraint(equalToConstant: halfScreenWidth),
             buyButton.heightAnchor.constraint(equalToConstant: 60)
            ])
    }
    
    func fillContent() {
        productImageView.sd_setImage(with: URL(string: productToDisplay.image))
        productTitle.text = productToDisplay.title
        productPrice.text = productToDisplay.price
        productDescription.text = productToDisplay.description
    }
    
    //MARK: - Actions
    
    @objc func addProductToCart() {
        cartItemViewModel.addProduct(productToDisplay)
    }
    
    @objc func cartButtonTapped() {
        let carListVC = CartListViewController(cartItemViewModel: CartItemVM(cartItemRepository: AppContainer.shared.cartItemRepository))
        carListVC.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.pushViewController(carListVC, animated: true)
    }
}
