//
//  ViewMemoryCollectionViewCell.swift
//  miniProject
//
//  Created by Manisha Reddy Narayan on 05/03/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
protocol ViewMemoryCollectionViewCellDelegate {
    func deleteMemory(cell: ViewMemoryCollectionViewCell)
}

class ViewMemoryCollectionViewCell: UICollectionViewCell,UIGestureRecognizerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var deletebtn: UIButton!
    var isEditing = false
    var delegate:ViewMemoryCollectionViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        deletebtn.buttonShape()
    }
    func displayAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            print("no results")
        }))
        
       self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteOnClick(_ sender: Any) {
        self.displayAlert(title: "Warning", message: "This memory is deleted permanently")
        delegate?.deleteMemory(cell: self)
    }
}
