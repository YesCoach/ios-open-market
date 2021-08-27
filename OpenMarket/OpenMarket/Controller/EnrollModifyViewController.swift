//
//  EnrollModifyViewController.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/27.
//

import UIKit
import PhotosUI


@available(iOS 14, *)
class EnrollModifyViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enrollModifyButton: UIBarButtonItem!
    
    let cellIdentifier = "photoCollectionViewCell"
    var images: [UIImage] = [UIImage(systemName: "photo")!]
    var limitedPhotos: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.delegate = self
        titleTextField.delegate = self
        currencyTextField.delegate = self
        priceTextField.delegate = self
        stockTextField.delegate = self
        discountedPriceTextField.delegate = self
        descriptionTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @IBAction func enrollModifyButton(_ sender: UIBarButtonItem) {
        var medias: [Media] = []
        let _ = images.removeFirst()
        for image in images {
            guard let media = Media(image: image, mimeType: .jpeg) else {
                return
            }
            medias.append(media)
        }
        guard let title = self.titleTextField.text else { return }
        guard let descriptions = self.descriptionTextField.text else { return }
        guard let price = self.priceTextField.text, let price = Int(price) else { return }
        guard let currency = self.currencyTextField.text else { return }
        guard let stock = self.stockTextField.text, let stock = Int(stock) else { return }
        guard let discountedPrice = self.discountedPriceTextField.text, let discountedPrice = Int(discountedPrice) else { return }
        guard let password = self.passwordTextField.text else { return }
        
        let parameter = PostItemData(title: title , descriptions: descriptions, price: price, currency: currency, stock: stock, discounted_price: discountedPrice, password: password)
        NetworkManager().commuteWithAPI(API: PostAPI(parameter: parameter.parameter(), items: medias)) { _ in
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

@available(iOS 14, *)
extension EnrollModifyViewController {
    @objc
    func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -300 // Move view 150 points upward
    }
    
    @objc
    func keyboardWillHide(_ sender: Notification) {
    self.view.frame.origin.y = 0 // Move view to original position
    }
    
}
//    @objc func keyboardWillShow(_ noti: NSNotification){
//        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue { let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            self.view.frame.origin.y -= keyboardHeight } }
//    @objc func keyboardWillHide(_ noti: NSNotification){
//        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue { let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            self.view.frame.origin.y += keyboardHeight } }
//
//
//    func addKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil) }
//
//    func removeKeyboardNotifications(){
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil) }
//
//}

