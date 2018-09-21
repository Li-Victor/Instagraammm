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

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
    
    var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
            PKHUD.sharedHUD.hide(afterDelay: 0.2)
            refreshControl.endRefreshing()
        }
    }
    
    private func fetchPosts() {
        let query = Post.query()!
        query.limit = 20
        query.addDescendingOrder("createdAt")
        
        // show HUD
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show(onView: tableView)
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                if let posts = objects as? [Post] {
                    self.posts = posts
                }
            }
        }
    }
    
    @objc private func onLogout() {
        print("logout")
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let post = posts[indexPath.row]
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
        
        // fetch items for table view
        fetchPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
