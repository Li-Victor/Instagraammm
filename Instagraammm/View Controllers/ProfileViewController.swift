//
//  ProfileViewController.swift
//  Instagraammm
//
//  Created by Victor Li on 9/21/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var nav: UINavigationItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @objc func onLogout(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up nav bar
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: #selector(ProfileViewController.onLogout))
        nav.rightBarButtonItem = logoutBarButtonItem
        
        let username = PFUser.current()!.username!
        nav.title = username
        
        profileImageView.layer.cornerRadius = 50
        
        // profile image
        profileImageView.af_setImage(withURL: URL(string: "https://api.adorable.io/avatars/100/\(username)")!)
        
        profileNameLabel.text = username
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
