//
//  ImageFormatter.swift
//  Virtual Tourist
//
//  Created by Mohamed Shiha on 8/28/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import UIKit

typealias AlbumSet = NSSet
typealias ImageArray = [UIImage]
typealias ImageData = Data

extension Array where Element: UIImage {
    
    func encodeToCoreDataStore() -> ImageData? {
        let CDataArray = NSMutableArray()
        
        for img in self {
            guard let imageRepresentation = img.jpegData(compressionQuality: 0.75) else {
                print("Unable to represent image as JPG")
                return nil
            }
            let data : NSData = NSData(data: imageRepresentation)
            CDataArray.add(data)
        }
        
        return try? NSKeyedArchiver.archivedData(withRootObject: CDataArray, requiringSecureCoding: false)
    }
}

extension NSSet {
    
    func encodeToCoreDataStore() -> ImageData? {
        let CDataArray = NSMutableArray()
        
        for img in self {
            guard let imageRepresentation = (img as! UIImage).jpegData(compressionQuality: 0.75) else {
                print("Unable to represent image as JPG")
                return nil
            }
            let data : NSData = NSData(data: imageRepresentation)
            CDataArray.add(data)
        }
        
        return try? NSKeyedArchiver.archivedData(withRootObject: CDataArray, requiringSecureCoding: false)
    }
}


extension ImageData {
    
    func decodeFromCoreDataStore() -> ImageArray? {
        if let storedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(self) as? NSArray {
            
            let imgArr = storedData.compactMap({
                return UIImage(data: $0 as! Data)
                })
            return imgArr
        } else {
            print("Unable to convert data to Image Array")
            return nil
        }
    }
}
