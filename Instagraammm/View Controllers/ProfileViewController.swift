//
//  ProfileViewController.swift
//  Instagraammm
//
//  Created by Victor Li on 9/21/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBAction func onLogout(_ sender: Any) {
        print("logout")
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
