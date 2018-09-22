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

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet private weak var nav: UINavigationItem!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var userPosts: [Post] = []
    
    @objc func onLogout(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPostCell", for: indexPath) as! UserCollectionViewCell
        cell.instagramPost = userPosts[indexPath.item]
        
        return cell
    }
    
    private func fetchPosts(from user: String) {
        let query = Post.query()!
        query.whereKey("authorUsername", equalTo: user)
        query.addDescendingOrder("createdAt")

        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                if let posts = objects as? [Post] {
                    self.userPosts += posts
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let username = PFUser.current()!.username!

        // set up nav bar
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: #selector(ProfileViewController.onLogout))
        nav.rightBarButtonItem = logoutBarButtonItem
        nav.title = username
        
        profileImageView.layer.cornerRadius = 50
        
        // profile image
        profileImageView.af_setImage(withURL: URL(string: "https://api.adorable.io/avatars/100/\(username)")!)
        
        profileNameLabel.text = username
        
        // calculating spacing between each cell
        let layout  = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 3
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        fetchPosts(from: username)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
