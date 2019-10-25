//
//  FlickrImagesDownloader.swift
//  Virtual Tourist
//
//  Created by Mohamed Shiha on 8/27/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    typealias dataTaskCompletionHandler = (_ result: AnyObject?, _ error : NSError?) -> Void
    
    func getRequest( _ parameters : [String:Any?], _ method : String, completion : @escaping dataTaskCompletionHandler ) -> URLSessionTask {
        
        let urlString = constructUrl(from: parameters, method)
    
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("There was an error with your request: \(error)")
                return
            }
            
            completion(data as AnyObject?, error as NSError?)
        }
        
        task.resume()
        
        return task
    }
}
