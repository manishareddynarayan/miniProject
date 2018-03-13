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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                let imageFile = PFFile(name: "image.png", data: imageData)
                memory["type"] = true
                memory["date"] = date
                memory["imageFile"] = imageFile
                memory["title"] = titleTextField.text
                memory["location"] = userLocation
                memory.saveInBackground { (success, error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if success {
                        self.titleTextField.text = nil
                        
                    } else {
                        print(error)
                    }
                }
            }
        } else {
            if let videoThumbnail = videoThumbnail {
                if let imageData = UIImagePNGRepresentation(videoThumbnail) {
                    let videoThumbnail = PFFile(name: "thubnail.png", data: imageData)
                    memory["thumbnail"] = videoThumbnail
                }
            }
            if let video = video {
                let videoFile:PFFile = PFFile(name:"consent.mp4", data:video as Data)!
                memory["videoFile"] = videoFile
            }
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            memory["date"] = date
            memory["title"] = titleTextField.text
            memory["location"] = userLocation
            memory.saveInBackground { (success, error) in
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                if success {
                    self.titleTextField.text = nil
                    
                } else {
                    print(error)
                }
            }
            
        }
    }
    func finishPassingVideo(controller: ChooseVideoViewController) {
        print("videoChoosen")
        chooseImageButton.isUserInteractionEnabled = false
        controller.navigationController?.popViewController(animated: true)
    }
    func finishPassingImage(controller: ChooseImageViewController) {
        print("image choosen")
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

