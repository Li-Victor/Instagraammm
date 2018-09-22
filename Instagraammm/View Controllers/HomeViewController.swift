//
//  HomeViewController.swift
//  Instagram
//
//  Created by Victor Li on 9/18/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse
import PKHUD
import AlamofireImage

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
    
    var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var isMoreDataLoading = false
    var loadingMorePostsActivityView: InfiniteScrollActivityView?
    
    private func fetchPosts() {
        let query = Post.query()!
        query.limit = 5
        query.skip = posts.count
        query.addDescendingOrder("createdAt")
        
        // show HUD
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show(onView: tableView)
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            self.isMoreDataLoading = false
            self.loadingMorePostsActivityView?.stopAnimating()
            PKHUD.sharedHUD.hide(afterDelay: 0.2)
            self.refreshControl.endRefreshing()
            if error == nil {
                if let posts = objects as? [Post], posts.count > 0 {
                    self.posts += posts
                }
            }
        }
    }
    
    @objc private func didPullToRefresh() {
        fetchPosts()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        let username = posts[section].authorUsername
        
        // Set the avatar
        profileView.af_setImage(withURL: URL(string: "https://api.adorable.io/avatars/30/\(username)")!)
        headerView.addSubview(profileView)
        
        let postLabel = UILabel(frame: CGRect(x: 50, y: 10, width: 270, height: 30))
        postLabel.text = username
        headerView.addSubview(postLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        cell.instagramPost = posts[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMorePostsActivityView?.frame = frame
                loadingMorePostsActivityView!.startAnimating()
                
                fetchPosts()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let post = posts[indexPath.section]
            let postDetailViewController = segue.destination as! PostDetailViewController
            postDetailViewController.instagramPost = post
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // add refresh control on top of tableView
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeViewController.didPullToRefresh), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMorePostsActivityView = InfiniteScrollActivityView(frame: frame)
        loadingMorePostsActivityView!.isHidden = true
        tableView.addSubview(loadingMorePostsActivityView!)
        
        // fetch items for table view
        fetchPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
