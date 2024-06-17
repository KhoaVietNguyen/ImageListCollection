//
//  PageViewController.swift
//  ImageListCollection
//
//  Created by Khoa Nguyen on 14/6/24.
//

import UIKit

class PageViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var data = [ImageModel]() {
        didSet {
            let preCount = collectionView?.numberOfItems(inSection: 0) ?? 0
            let currentCount = self.data.count
         
            if preCount != 0 && preCount < currentCount {
                self.addNewItem()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(ImageCell.self)
        
        let flowLayout =  UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    func addNewItem() {
        self.collectionView.performBatchUpdates({
        // Update data source here (e.g., add/remove items in your data model)
        
        // Perform collection view updates within the closure
            let newItems = [IndexPath(item: self.data.count - 1, section: 0)]
            self.collectionView.insertItems(at: newItems)
      }, completion: { (finished) in
        // Handle completion (optional)
      })
    }
}

extension PageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.data = data[indexPath.row]
        cell.getImage()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = CGFloat(integerLiteral: .PAGE_COLUMN)
        let spacing: CGFloat = 2
        let totalHorizontalSpacing = (columns - 1) * spacing
        let size = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previewVC = ImagePreviewViewController()
        previewVC.imageUrl = data[indexPath.row].link
        previewVC.id = data[indexPath.row].id
        let vc = UINavigationController(rootViewController: previewVC)
        vc.modalPresentationStyle = .overFullScreen // if you want to present it in full screen mode
       // present(vc, animated: true, completion: nil)
    }
}

class ImagePreviewViewController: UIViewController {
    
    var imageView = ImageLoader()
    var imageUrl: String? // Property to store the image URL
    var id : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the image view content mode to aspect fit
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        // Load the image from URL
        if let idImage = self.id{
            imageView.loadImageCache(id: idImage)// Replace with your preferred image loading method
        } else if let url = self.imageUrl{
            imageView.loadImageCache(url)
        } else {
            // Handle cases where imageUrl is nil or invalid
            print("Error: Invalid image URL")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupHeader()
    }
    
    func setupHeader() {
        self.navigationController?.navigationBar.topItem?.title = "Profile Settings"
        self.navigationItem.title = "Image Preview"
        let buttonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action:  #selector(addTapped))
        navigationItem.rightBarButtonItem = buttonItem
    }
    
    @objc func addTapped() {
        self.dismiss(animated: true)
    }
}
