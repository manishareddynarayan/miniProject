//
//  PreviewImageViewController.swift
//  miniProject
//
//  Created by Manisha Reddy Narayan on 09/03/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import Parse

class PreviewImageViewController: UIViewController {
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var files = [PFObject]()
    var image:UIImage?
    var location:String?
    var title1:String?
    var date:String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        previewImageView.image = image
        titleLabel.text = title1
        locationLabel.text = location
        dateLabel.text = date
    }
    @IBAction func share(_ sender: Any) {
        let activityVc = UIActivityViewController(activityItems: [self.previewImageView.image!], applicationActivities: nil)
        activityVc.popoverPresentationController?.sourceView = self.view
        self.present(activityVc, animated: true, completion: nil)
    }
}
