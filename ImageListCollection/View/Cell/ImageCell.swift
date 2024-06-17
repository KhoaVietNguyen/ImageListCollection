//
//  ImageCell.swift
//  ImageListCollection
//
//  Created by Khoa Nguyen on 13/6/24.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imgView: ImageLoader!
    var data : ImageModel? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView.layer.cornerRadius = 7
    }
    
    func getImage(){
        guard let dataImage = data else { return }
        if let imageFromCache = imageCache.object(forKey: dataImage.id as AnyObject) as? UIImage {
            self.imgView.image = imageFromCache
        } else if let imgUrl = URL(string: .baseImageUrl){
            self.imgView.id = dataImage.id
            self.imgView.loadImageWithUrl(imgUrl){ url in
                //dataImage.link =  url
            }
        }
    }
}
