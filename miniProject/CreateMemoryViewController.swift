//
//  CreateMemoryViewController.swift
//  miniProject
//
//  Created by Manisha Reddy Narayan on 06/03/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import CoreLocation
import TextFieldEffects
import Parse
class CreateMemoryViewController: UIViewController,ChooseImageViewControllerDelegate ,ChooseVideoViewControllerDelegate, ChooseLocationViewControllerDelegate{
    
    @IBOutlet weak var titleTextField: JiroTextField!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var chooseVideoButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var chooseLocationButton: UIButton!
    @IBOutlet weak var createMemoryOnClick: UIButton!
    var image:UIImage?
    var userLocation:String?
    var videoThumbnail:UIImage?
    var video:NSData?
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseImageButton.buttonShape()
        chooseVideoButton.buttonShape()
        chooseLocationButton.buttonShape()
        createMemoryOnClick.buttonShape()
        activityIndicator.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
    }
    func displayAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            print("check error")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        self.performSegue(withIdentifier: "ChooseImage", sender: self)
    }
    @IBAction func chooseVideo(_ sender: Any) {
        self.performSegue(withIdentifier: "ChooseVideo" , sender: self)
    }
    
    @IBAction func chooseLocation(_ sender: Any) {
        self.performSegue(withIdentifier: "locationSegue" , sender: self)
    }
    
    @IBAction func CreateMemory(_ sender: Any) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyy\nH:mm:ss"
        let date = formatter.string(from: now)
        let memory = PFObject(className: "Memory")
        memory["userid"] = PFUser.current()?.objectId
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                activityIndicator.isHidden = false
                activityIndicator.hidesWhenStopped = true
                activityIndicator.color = UIColor.black
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                let imageFile = PFFile(name: "image.png", data: imageData)
                memory["type"] = true
                memory["date"] = date
                if imageFile != nil {
                    memory["imageFile"] = imageFile
                    memory["title"] = titleTextField.text
                    if((userLocation != nil)){
                        memory["location"] = userLocation
                    }else{
                        userLocation = ""
                    }
                    memory.saveInBackground { (success, error) in
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        UIApplication.shared.endIgnoringInteractionEvents()
                        if success {
                            self.displayAlert(title: "successful", message: "Your memory is Saved!")
                            self.titleTextField.text = nil
                            
                        } else {
                            self.displayAlert(title: "Error", message: "Please enter All the values")
                        }
                    }
                }
                else{
                    activityIndicator.stopAnimating()
                }
            }
        }else if let video = video {
            if let videoThumbnail = videoThumbnail {
                if let imageData = UIImagePNGRepresentation(videoThumbnail) {
                    let videoThumbnail = PFFile(name: "thubnail.png", data: imageData)
                    memory["thumbnail"] = videoThumbnail
                }
            }
            activityIndicator.isHidden = false
            activityIndicator.hidesWhenStopped = true
            activityIndicator.color = UIColor.black
            activityIndicator.startAnimating()
            let videoFile:PFFile = PFFile(name:"consent.mp4", data:video as Data)!
            memory["videoFile"] = videoFile
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            memory["date"] = date
            memory["title"] = titleTextField.text
            if((userLocation != nil)){
                memory["location"] = userLocation
            }else{
                userLocation = ""
            }
            memory.saveInBackground { (success, error) in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                UIApplication.shared.endIgnoringInteractionEvents()
                if success {
                    self.displayAlert(title: "successful", message: "Your memory is Saved!")
                    self.titleTextField.text = nil
                } else {
                    self.displayAlert(title: "Error", message: "Please enter All the values")
                }
            }
        } else {
            self.displayAlert(title: "Error", message: "Please enter All the values")
        }
    }
    func finishPassingVideo(controller: ChooseVideoViewController) {
        print("videoChoosen")
        chooseImageButton.alpha = 0.8
        chooseImageButton.isUserInteractionEnabled = false
        controller.navigationController?.popViewController(animated: true)
    }
    func finishPassingImage(controller: ChooseImageViewController) {
        print("image choosen")
        chooseVideoButton.alpha = 0.8
        chooseVideoButton.isUserInteractionEnabled = false
        controller.navigationController?.popViewController(animated: true)
    }
    func finishPassingLocation(controller: ChooseLocationViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChooseImageViewController {
            destination.delegate = self
        }
        if let destination = segue.destination as? ChooseVideoViewController {
            destination.delegate = self
        }
        if let destination = segue.destination as? ChooseLocationViewController {
            destination.delegate = self
        }
    }
}

