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
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var instagramPost: Post! {
        didSet {
            postImageView.file = instagramPost.media
            postImageView.loadInBackground()
            
            usernameLabel.text = PFUser.current()!.username!
            
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
