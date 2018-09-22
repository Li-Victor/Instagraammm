//
//  UserCollectionViewCell.swift
//  Instagraammm
//
//  Created by Victor Li on 9/21/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: PFImageView!
    
    var instagramPost: Post! {
        didSet {
            postImageView.file = instagramPost.media
            postImageView.loadInBackground()
        }
    }
}
