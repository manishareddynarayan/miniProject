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

class CreateMemoryViewController: UIViewController {
    @IBOutlet weak var titleTextField: JiroTextField!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var chooseVideoButton: UIButton!
    @IBOutlet weak var chooseLocationButton: UIButton!
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseImageButton.buttonShape()
        chooseVideoButton.buttonShape()
        chooseLocationButton.buttonShape()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

