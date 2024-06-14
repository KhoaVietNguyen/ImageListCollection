//
//  PageViewController.swift
//  ImageListCollection
//
//  Created by Khoa Nguyen on 14/6/24.
//

import UIKit

class PageViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var data = [ImageModel]()
    
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
}

extension PageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        if let imgUrl = URL(string: .baseImageUrl){
            cell.imgView.loadImageWithUrl(imgUrl)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 7
        let spacing: CGFloat = 2
        let totalHorizontalSpacing = (columns - 1) * spacing
        let size = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        return CGSize(width: size, height: size)
    }
}
