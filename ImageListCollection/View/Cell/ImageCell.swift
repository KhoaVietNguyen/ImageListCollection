//
//  ImageCell.swift
//  ImageListCollection
//
//  Created by Khoa Nguyen on 13/6/24.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imgView: ImageLoader!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView.layer.cornerRadius = 7
        
    }
}
