//
//  PostCell.swift
//  Instagraammm
//
//  Created by Victor Li on 9/19/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class PostCell: UITableViewCell {

    @IBOutlet weak var headerUserImageView: UIImageView!
    @IBOutlet weak var headerUsernameLabel: UILabel!
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var instagramPost: Post! {
        didSet {
            headerUserImageView.clipsToBounds = true
            headerUserImageView.layer.cornerRadius = 15
            headerUserImageView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
            headerUserImageView.layer.borderWidth = 1
            
            headerUserImageView.af_setImage(withURL: URL(string: "https://api.adorable.io/avatars/30/\(instagramPost.authorUsername)")!)
            
            headerUsernameLabel.text = instagramPost.authorUsername
            
            postImageView.file = instagramPost.media
            postImageView.loadInBackground()
            
            usernameLabel.text = instagramPost.authorUsername
            
            captionLabel.text = instagramPost.caption
            
            dateLabel.text = instagramPost.date
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
