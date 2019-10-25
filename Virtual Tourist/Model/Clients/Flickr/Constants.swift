//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Mohamed Shiha on 8/14/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation


class FlickrClient {
    
    static let shared = FlickrClient()
    
    // Mark: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.flickr.com"
        static let ApiPath = "/services/rest/"
        
        static let Api_Key = "4c759f292274916af4cb8ff823ad66ef"
        
        static let json = "json"
        static let noJsonCallBack = "1"
    }
    
    // MARK: Methods
    struct Methods {
        static let search = "flickr.photos.search"
    }
    
    // Mark: QueryParamterKeys
    struct QueryParamterKeys {
        static let Api_Key = "api_key"
        static let method = "method"
        static let bbox = "bbox"
        static let page = "page"
        static let perPage = "per_page"
        static let extras = "extras"
        static let format = "format"
        static let noJsonCallBack = "nojsoncallback"
    }
    
    // Mark: JsonResponseKeys
    struct JsonResponseKeys {
        
        static let photos = "photos"
        static let photo = "photo"

        static let url_m = "url_m"
    }
    
    func constructUrl(from parameters : [String:Any?], _ withPathExtention : String?) -> String {
        
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath
        
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: QueryParamterKeys.method, value:
            Methods.search))
        
        queryItems.append(URLQueryItem(name: QueryParamterKeys.Api_Key, value:
            Constants.Api_Key))
        
        queryItems.append(URLQueryItem(name: QueryParamterKeys.extras, value:
            JsonResponseKeys.url_m))
        
        queryItems.append(URLQueryItem(name: QueryParamterKeys.perPage, value:
            "30"))
        
        queryItems.append(URLQueryItem(name: QueryParamterKeys.format, value:
            Constants.json))
        
        queryItems.append(URLQueryItem(name: QueryParamterKeys.noJsonCallBack, value:
            Constants.noJsonCallBack))
        
        for queryItem in parameters {
            queryItems.append(URLQueryItem(name: queryItem.key, value: queryItem.value as? String))
        }
        components.queryItems = queryItems
        
        return (components.url?.absoluteString)!
    }
}
