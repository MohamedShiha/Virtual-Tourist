//
//  FlickrImageDownloader.swift
//  Virtual Tourist
//
//  Created by Mohamed Shiha on 8/27/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import UIKit

extension FlickrClient {
    
    private func getImagesData(_ parameters : [String:Any?], completionHandler : @escaping(_ imagesData: [String:AnyObject]?, _ error : String?) -> Void) {
        
        let _ = getRequest(parameters, Methods.search) { (data, error) in
            
            if let data = data {
                var jsonData : [String:AnyObject]! = nil
                do {
                    jsonData = try JSONSerialization.jsonObject(with: data as! Data, options: .allowFragments) as? [String:AnyObject]
                } catch {
                    completionHandler(nil, error.localizedDescription)
                    return
                }
                
                completionHandler(jsonData, "")
            }
        }
    }
    
    func getImages( _ parameters : [String:Any?], completionHandler : @escaping(_ imagesData: [UIImage]?, _ error : String?) -> Void) {
        
        getImagesData(parameters) { (imageData, error) in
            
            if let imageData = imageData {
                
                if let photos = imageData[JsonResponseKeys.photos] as? [String:AnyObject] {
                    if let photoArr = photos[JsonResponseKeys.photo] as? [[String:AnyObject]] {
                        var images = [UIImage]()
                        for photo in photoArr {
                            if let url_m = photo[JsonResponseKeys.url_m] as? String {
                                let photoData = try? Data(contentsOf: URL(string: url_m)!)
                                images.append(UIImage(data: photoData!)!)
                            }
                        }
                        completionHandler(images, nil)
                    } else {
                        completionHandler(nil, "Coutldn't find \(JsonResponseKeys.photos) key in json data")
                    }
                } else {
                    completionHandler(nil, "Coutldn't find \(JsonResponseKeys.photo) key in json data")
                }
            } else {
                completionHandler(nil, "No data was returned from the Api")
            }
        }
    }
}
