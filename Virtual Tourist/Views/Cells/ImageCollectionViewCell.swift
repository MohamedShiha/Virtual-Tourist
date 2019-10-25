//
//  ImageCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Mohamed Shiha on 8/28/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    // MARK : Oulets
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func generateCell ( _ image : UIImage) {
        cellImage.image = image
    }
}
