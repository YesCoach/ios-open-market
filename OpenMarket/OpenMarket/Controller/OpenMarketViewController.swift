//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lodingIndicator: UIActivityIndicatorView!
    
    private var products: [ItemData] = []
    private var page = 15
    private let networkManager = NetworkManager()
    private let cellIdentifier = "customCollectionViewCell"
    private let addVCIdentifier = "addItemViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestNextPage()
    }
    
//    @IBAction func AddItemButton(_ sender: UIBarButtonItem) {
//        guard let addVC = self.storyboard?.instantiateViewController(identifier: self.addVCIdentifier) else { return }
//        addVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록", style: .done, target: .none, action: .none)
//        self.navigationController?.pushViewController(addVC, animated: true)
//    }
    
    private func requestNextPage() {
        lodingIndicator.startAnimating()
        lodingIndicator.isHidden = false
        
        self.networkManager.commuteWithAPI(API: GetItemsAPI(page: page)) { result in
            if case .success(let data) = result {
                guard let product = try? JsonDecoder.decodedJsonFromData(type: ItemsData.self, data: data) else {
                    return
                }
                self.products.append(contentsOf: product.items)
                self.page += 1
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.lodingIndicator.stopAnimating()
                    self.lodingIndicator.isHidden = true
                }
            }
        }
    }
}

extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        let productForRow = products[indexPath.item]
        cell.configure(item: productForRow)
        
        return cell
    }
}

extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
        
        let bounds = collectionView.bounds
        var width = bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
        var height = bounds.height - (layout.sectionInset.top + layout.sectionInset.bottom)
        
        if UIDevice.current.orientation.isLandscape {
            width = (width - (layout.minimumInteritemSpacing * 3)) / 4
            height = width * 1.5
        } else {
            width = (width - (layout.minimumInteritemSpacing * 1.5)) / 2
            height = width * 1.5
        }
        return CGSize(width: width.rounded(.down), height: height.rounded(.down))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension OpenMarketViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let lastItem = products.count - 1
        for indexPath in indexPaths {
            if lastItem == indexPath.item {
                requestNextPage()
            }
        }
    }
}
