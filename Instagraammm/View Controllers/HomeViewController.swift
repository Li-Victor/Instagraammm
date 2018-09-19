//
//  HomeViewController.swift
//  Instagram
//
//  Created by Victor Li on 9/18/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var homeFeedNavItem: UINavigationItem!
    
    @IBOutlet private weak var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
    
    var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let resizedImage = resize(image: originalImage, newSize: CGSize(width: 300, height: 300))
        
        Post.postUserImage(image: resizedImage, withCaption: "ride or die") { (success: Bool, error: Error?) in
            if success {
                print("successfully posted image")
                // Dismiss UIImagePickerController to go back to your original view controller
                self.fetchPosts()
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    private func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func fetchPosts() {
        // construct query
        
        let query = Post.query()!
        query.limit = 20
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                if let posts = objects as? [Post] {
                    self.posts = posts
                }
            }
        }
    }
    
    @objc private func onLogout() {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    @objc private func takePhoto() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func didPullToRefresh() {
        fetchPosts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        cell.instagramPost = posts[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // set up nav bar
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: #selector(HomeViewController.onLogout))
        
        let takePhotoBarButtonItem = UIBarButtonItem(image: UIImage(named: "insta_camera_btn"), style: .plain, target: nil, action: #selector(HomeViewController.takePhoto))

        homeFeedNavItem.leftBarButtonItem = logoutBarButtonItem
        homeFeedNavItem.rightBarButtonItem = takePhotoBarButtonItem
        
        // add refresh control on top of tableView
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeViewController.didPullToRefresh), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // fetch items for table view
        fetchPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
