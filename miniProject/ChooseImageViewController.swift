//
//  ImageViewController.swift
//  miniProject
//
//  Created by Manisha Reddy Narayan on 07/03/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import Parse
protocol ChooseImageViewControllerDelegate {
    func finishPassingImage(controller: ChooseImageViewController)
}
class ChooseImageViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var gotoGallery: UIButton!
    @IBOutlet weak var ChooseImageView: UIImageView!
    @IBOutlet weak var imageDone: UIButton!
    var delegate: ChooseImageViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        gotoGallery.buttonShape()
        imageDone.buttonShape()
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
    
    @IBAction func doneImageOnClick(_ sender: Any) {
        delegate?.finishPassingImage(controller: self)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ChooseImageView.image = image
            self.imageDone.isHidden = false
            let viewControllers = self.navigationController!.viewControllers as [UIViewController];
            for aViewController:UIViewController in viewControllers {
                if aViewController.isKind(of: CreateMemoryViewController.self) {
                    (aViewController as? CreateMemoryViewController)?.image = image
                }
            }
            
        }
        else
        {
            print("no image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
