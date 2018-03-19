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
    @IBAction func deleteOnClick(_ sender: Any) {
        delegate?.deleteMemory(cell: self)
    }
}
