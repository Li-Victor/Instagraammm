//
//  NewPostViewController.swift
//  Instagraammm
//
//  Created by Victor Li on 9/20/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit
import Parse

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var captionField: UITextField!
    @IBOutlet private weak var shareButton: UIButton!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let resizedImage = resize(image: originalImage, newSize: CGSize(width: 300, height: 300))
        self.dismiss(animated: true, completion: nil)
        
        imageView.contentMode = .scaleToFill
        imageView.image = resizedImage
        
        shareButton.isEnabled = true
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func onSharePost(_ sender: Any) {
        let image = imageView.image!
        let caption = captionField.text!
        Post.postUserImage(image: image, withCaption: caption) { (success: Bool, error: Error?) in
            if success {
                self.performSegue(withIdentifier: "goToHomeSegue", sender: nil)
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
        
    }
    
    @IBAction func onTapNewPhoto(_ sender: Any) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionField.delegate = self
        captionField.returnKeyType = .done
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
