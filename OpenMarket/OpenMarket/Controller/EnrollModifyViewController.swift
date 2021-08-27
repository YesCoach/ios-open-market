//
//  EnrollModifyViewController.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/27.
//

import UIKit
import PhotosUI


@available(iOS 14, *)
class EnrollModifyViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "photoCollectionViewCell"
    var images: [UIImage] = [UIImage(systemName: "photo")!]
    var limitedPhotos: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

@available(iOS 14, *)
extension EnrollModifyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(image: images[indexPath.item])
        
        return cell
    }
    
}

@available(iOS 14, *)
extension EnrollModifyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell else {
        //            return
        //        }
        if images.count <= 5 {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = limitedPhotos
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        }
    }
}

@available(iOS 14, *)
extension EnrollModifyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        let bounds = collectionView.bounds
        
        var width = bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
        var height = bounds.height - (layout.sectionInset.top + layout.sectionInset.bottom)
        
        width = (width - (layout.minimumInteritemSpacing * 3)) / 3
        height = width
        
        return CGSize(width: width.rounded(.down), height: height.rounded(.down))
    }
}

@available(iOS 14, *)
extension EnrollModifyViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var itemProviders = [NSItemProvider?]()
        for result in results {
            itemProviders.append(result.itemProvider)
            
        }
        for itemProvider in itemProviders {
            if let itemProvider = itemProvider,
               itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let image = image as? UIImage {
                        self.images.append(image)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.limitedPhotos -= 1
                        }
                    }
                }
            }
        }
    }
}
