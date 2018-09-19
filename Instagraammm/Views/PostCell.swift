//
//  PostCell.swift
//  Instagraammm
//
//  Created by Victor Li on 9/19/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse

class PostCell: UITableViewCell {

    @IBOutlet weak var postImageView: PFImageView!
    
    var instagramPost: PFObject! {
        didSet {
            self.postImageView.file = instagramPost["media"] as? PFFile
            self.postImageView.loadInBackground()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
