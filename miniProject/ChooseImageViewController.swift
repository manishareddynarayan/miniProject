//
//  ImageViewController.swift
//  miniProject
//
//  Created by Manisha Reddy Narayan on 07/03/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
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
        }
        else
        {
            print("no image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addImageOnClick(_ sender: Any) {
        
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
