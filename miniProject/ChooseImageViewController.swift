//
//  ImageViewController.swift
//  miniProject
//
//  Created by Manisha Reddy Narayan on 07/03/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import Parse
class ChooseImageViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var addImage: UIButton!
    @IBOutlet weak var gotoGallery: UIButton!
    @IBOutlet weak var ChooseImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        gotoGallery.buttonShape()
        addImage.buttonShape()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func gotoGalleryOnClick(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        ChooseImageView.image = image
//                    let viewControllers = self.navigationController!.viewControllers as [UIViewController];
//                    for aViewController:UIViewController in viewControllers {
//                        if aViewController.isKind(of: CreateMemoryViewController.self) {
//                            (aViewController as? CreateMemoryViewController)?.image = image
//                        }
//                    }

        }
        else
        {
            print("no image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addImageOnClick(_ sender: Any) {
        if let image = ChooseImageView.image {
            
            let memory = PFObject(className: "Memory")
            memory["userid"] = PFUser.current()?.objectId
            if let imageData = UIImagePNGRepresentation(image) {
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                let imageFile = PFFile(name: "image.png", data: imageData)
                memory["type"] = "image"
                memory["imageFile"] = imageFile
                memory.saveInBackground(block: { (success,error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if success {
                    
                        self.ChooseImageView.image = nil
                        
                    } else {
                        print(error)
                        
                    }
                    
                    
                })
            }
            
            
        }
//        self.performSegue(withIdentifier: "addedImageSegue", sender: self)
        
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
