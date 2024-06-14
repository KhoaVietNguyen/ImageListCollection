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

    var imageURL: String?

    let activityIndicator = UIActivityIndicatorView()

    func loadImageWithUrl(_ url: URL, completed : () -> Void = {}) {

        // setup activityIndicator...
        activityIndicator.color = .tintColor

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
                    imageCache.setObject(imageToCache, forKey: url.absoluteString as AnyObject)
                }
                self.activityIndicator.stopAnimating()
            })
        }).resume()
        completed()
    }
    
    func loadImageCache(_ url: String, placeholder: UIImage? = nil) {
         //retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
        }
    }
}
