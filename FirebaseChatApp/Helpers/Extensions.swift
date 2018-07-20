//
//  File.swift
//  FirebaseChatApp
//
//  Created by kiran on 7/20/18.
//  Copyright © 2018 kiran. All rights reserved.
//

import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()
//class CustomImageView: UIImageView {
//    var imageUrlString: String?
//    func loadImageWithCacheWithUrlString(urlString: String)  {
//        let url = URL(string: urlString)
//        imageUrlString = urlString
//
//        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
//            self.image = imageFromCache
//            return
//        }
//        URLSession.shared.dataTask(with: url!) { (data, response, error) in
//            if error != nil{
//                print(error!)
//                return
//        }
//            DispatchQueue.main.async {
//               let imageToCache = UIImage(data: data!)
//                if self.imageUrlString == urlString {
//                    self.image = imageToCache
//                }
//                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
//            }
//        }.resume()
//    }
//
//}
extension UIImageView {
   func loadImageWithCacheWithUrlString(urlString: String) {
    
    let url = URL(string: urlString)
    //it check the image in the cache firest
    if let imagesFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
        self.image = imagesFromCache
        return
    }
   //it downloads the image if there is no image in cachź
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.sync {
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                self.image = imageToCache
            }
            }.resume()

    }
}
