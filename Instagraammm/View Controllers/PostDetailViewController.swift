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
    
    var instagramPost: PFObject!
    
    @IBAction func onBackAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postImageView.file = instagramPost["media"] as? PFFile
        postImageView.loadInBackground()
        
        // get username
        let user = instagramPost["author"] as! PFUser
        let query = PFUser.query()!
        query.whereKey("objectId", equalTo: user.objectId!)
        query.getFirstObjectInBackground(block: { (object: PFObject?, error: Error?) in
            if let user = object as? PFUser {
                let username = user.username!
                
                let caption = self.instagramPost["caption"] as! String
                self.descriptionLabel.text = "\(username): \(caption)"
                
                let date = self.instagramPost["date"] as! String
                self.dateLabel.text = date
            }
        })
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
