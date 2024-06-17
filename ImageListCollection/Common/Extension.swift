//
//  Extension.swift
//  ImageListCollection
//
//  Created by Khoa Nguyen on 13/6/24.
//

import Foundation
import UIKit

extension String {
    static let baseImageUrl = "http://loremflickr.com/200/200/dog"
}

extension Int {
    static let COUNT_ITEM_DEFAULT = 138
    static var PAGE_MAX_COUNT = 70
    static let PAGE_COLUMN = 7
    static let spacing: CGFloat = 2
    static let totalHorizontalSpacing = CGFloat((PAGE_COLUMN - 1)) * spacing
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: Bundle(for: T.self))
        register(nib, forCellWithReuseIdentifier: nibName)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Failed to dequeue cell with identifier: \(String(describing: T.self))")
        }
        return cell
    }
    
    func scrollToLastItem() {
        let lastSection = self.numberOfSections - 1
        let lastRow = self.numberOfItems(inSection: lastSection)
        let indexPath = IndexPath(row: lastRow - 1, section: lastSection)
        self.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    func getLastIndexPath() -> IndexPath{
        let lastSection = self.numberOfSections - 1
        let lastRow = self.numberOfItems(inSection: lastSection)
        return IndexPath(row: lastRow, section: lastSection)
    }
}

public class ImageProvider {
    
    // for any image located in bundle where this class has built
    public static func image(named: String, defaultImg: String) -> UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(named: named, in: Bundle(for: self), with: nil) ?? UIImage.image(named: defaultImg)
        } else {
            return UIImage()
        }
    }
}
extension UIImage {
    static func image(named: String, defaultImg: String = "photo") -> UIImage? {
        return ImageProvider.image(named: named, defaultImg: defaultImg)
    }
    
    func resize(targetSize: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: targetSize)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        draw(in: rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}
