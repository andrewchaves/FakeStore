//
//  ProductTableViewCell.swift
//  FakeStore
//
//  Created by Andrew Vale on 05/02/25.
//

import Foundation
import UIKit


class ProductTableViewCell: UITableViewCell {
    
    var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.gray.cgColor
        imageView.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        imageView.layer.cornerRadius = 5.0
        imageView.layer.shadowOpacity = 0.5
        return imageView
    }()
    
    var productTitle: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    var productPrice: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = .gray
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    //MARK: - Cell Configuration
    func setupView() {
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productTitle.translatesAutoresizingMaskIntoConstraints = false
        productPrice.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(productImageView)
        self.contentView.addSubview(productTitle)
        self.contentView.addSubview(productPrice)
        
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalToConstant: 80.0),
            productImageView.heightAnchor.constraint(equalToConstant: 80.0),
            productImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            productImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0),
            productImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20.0),
            
            // Product title
            productTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            productTitle.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16.0),
            productTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8.0),
            
            // Product price
            productPrice.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 4.0),
            productPrice.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16.0),
            productPrice.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -4.0)
    
        ])
    }
    
    func fill(image:String,
              title: String,
              price: String) {
        self.productImageView.image = UIImage(named: "")
        self.productTitle.text = title
        self.productPrice.text = price
    }
}


