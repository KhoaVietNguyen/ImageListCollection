//
//  ImageCache.swift
//  ImageListCollection
//
//  Created by Khoa Nguyen on 13/6/24.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader: UIImageView {
    var id : Int = 0

    var imageURL: String?

    let activityIndicator = UIActivityIndicatorView()

    func loadImageWithUrl(_ url: URL, completed : @escaping (String) -> Void = { _ in}) {

        // setup activityIndicator...
        activityIndicator.color = .systemBlue.withAlphaComponent(0.5)

        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image = nil
        DispatchQueue.main.async(execute: {
            self.activityIndicator.startAnimating()
        })
    
        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                })
                return
            }

            DispatchQueue.main.async(execute: {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData), let url = response?.url {
                    self.image = imageToCache
                    self.imageURL = url.absoluteString
                    completed(url.absoluteString)
                    imageCache.setObject(imageToCache, forKey: self.id as AnyObject)
                }
                self.activityIndicator.stopAnimating()
            })
        }).resume()
    }
    
    func loadImageCache(_ url: String = "", placeholder: UIImage? = nil, id: Int? = nil) {
         //retrieves image if already available in cache
        if let idImage = id, let imageFromCache = imageCache.object(forKey: idImage as AnyObject) as? UIImage {
            self.image = imageFromCache
        } else {
            if  let url = URL(string: url) {
                self.loadImageWithUrl(url)
            } else {
                if  let url = URL(string: .baseImageUrl) {
                    self.loadImageWithUrl(url)
                }
            }
        }
    }
}
