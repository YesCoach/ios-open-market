//
//  PhotoCollectionViewCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/27.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(image: UIImage) {
        self.imageView.image = image
    }
}
