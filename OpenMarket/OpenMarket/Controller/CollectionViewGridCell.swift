//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/09/03.
//

import UIKit

class CollectionViewGridCell: UICollectionViewCell {
    static let cellID = "GridCell"
    private var imageView = UIImageView()
    private var stackView = UIStackView()
    private var titleLabel = UILabel()
    private var priceLabel = UILabel()
    private var discountedPriceLabel = UILabel()
    private var stockLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCellComponent()
        setUpConstraints()
        setUpStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(item: Item) {
        item.image { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }

        titleLabel.text = item.title
        let priceWithCurrency = item.currency + " " + item.price.withDigit

        if let discountedPrice = item.discountedPrice {
            priceLabel.attributedText = priceWithCurrency.redStrikeThrough()
            priceLabel.textColor = .red
            discountedPriceLabel.text = item.currency + " " + discountedPrice.withDigit
            discountedPriceLabel.textColor = .gray
            discountedPriceLabel.isHidden = false
        } else {
            priceLabel.text = priceWithCurrency
            priceLabel.textColor = .gray
        }

        if item.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .orange
        } else {
            stockLabel.text = "잔여수량 : \(item.stock.withDigit)"
            stockLabel.textColor = .gray
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = .none
        priceLabel.attributedText = nil
        discountedPriceLabel.text = .none
        discountedPriceLabel.isHidden = true
    }

    private func setUpCellComponent() {
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fillEqually

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(discountedPriceLabel)
        stackView.addArrangedSubview(stockLabel)

        self.contentView.addSubview(imageView)
        self.contentView.addSubview(stackView)
    }

    private func setUpConstraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.discountedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.stockLabel.translatesAutoresizingMaskIntoConstraints = false

        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.6).isActive = true

        stackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6).isActive = true
    }

    private func setUpStyle() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 10.0

        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center

        titleLabel.adjustsFontSizeToFitWidth = true
        priceLabel.adjustsFontSizeToFitWidth = true
        discountedPriceLabel.adjustsFontSizeToFitWidth = true
        stockLabel.adjustsFontSizeToFitWidth = true
    }
}
