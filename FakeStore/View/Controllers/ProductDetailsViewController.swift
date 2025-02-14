//
//  ProductDetailsViewController.swift
//  FakeStore
//
//  Created by Andrew Vale on 13/02/25.
//

import Foundation
import UIKit
import SDWebImage

class ProductDetailsViewController: UIViewController {
    
    var productToDisplay: ProductForUI
    
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
        return text
    }()
    
    init (productToDisplay: ProductForUI) {
        self.productToDisplay = productToDisplay
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bluidScreen()
        productImageView.sd_setImage(with: URL(string: productToDisplay.image))
        productTitle.text = productToDisplay.title
        productPrice.text = productToDisplay.price
        productDescription.text = productToDisplay.description
    }
    
    //MARK: - Setup
    func bluidScreen() {
        let halfScreenWidth = self.view.frame.size.width/2
        
        self.title = "Product Details"
        self.view.backgroundColor = .white
        
        productView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productTitle.translatesAutoresizingMaskIntoConstraints = false
        productPrice.translatesAutoresizingMaskIntoConstraints = false
        productDescription.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(productView)
        productView.addSubview(productImageView)
        self.view.addSubview(productTitle)
        self.view.addSubview(productPrice)
        self.view.addSubview(productDescription)
        
        NSLayoutConstraint.activate(
            [productView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 24),
             productView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
             productView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
             productView.heightAnchor.constraint(equalToConstant: 320),
             
             productImageView.topAnchor.constraint(equalTo: productView.topAnchor),
             productImageView.leadingAnchor.constraint(equalTo: productView.leadingAnchor),
             productImageView.trailingAnchor.constraint(equalTo: productView.trailingAnchor),
             productImageView.bottomAnchor.constraint(equalTo: productView.bottomAnchor),
             
             productTitle.topAnchor.constraint(equalTo: productImageView.bottomAnchor,constant: 8),
             productTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
             productTitle.widthAnchor.constraint(equalToConstant: halfScreenWidth),
             productTitle.heightAnchor.constraint(equalToConstant: 120),
             
             productPrice.topAnchor.constraint(equalTo: productImageView.bottomAnchor,constant: 8),
             productPrice.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
             productPrice.widthAnchor.constraint(equalToConstant: halfScreenWidth),
             
             productDescription.topAnchor.constraint(equalTo: productTitle.bottomAnchor,constant: 8),
             productDescription.leadingAnchor.constraint(equalTo: productView.leadingAnchor),
             productDescription.trailingAnchor.constraint(equalTo: productView.trailingAnchor),
             productDescription.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
}
