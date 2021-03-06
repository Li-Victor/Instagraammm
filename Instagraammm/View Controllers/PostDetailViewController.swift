//
//  PostDetailViewController.swift
//  Instagraammm
//
//  Created by Victor Li on 9/19/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse

class PostDetailViewController: UIViewController {

    @IBOutlet weak var postImageView: PFImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var instagramPost: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postImageView.file = instagramPost.media
        
        // get description
        let authorUsername = instagramPost.authorUsername
        let caption = instagramPost.caption
        descriptionLabel.text = "\(authorUsername): \(caption)"
        
        dateLabel.text = instagramPost.date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
