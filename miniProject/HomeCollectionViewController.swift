//
//  HomeCollectionViewController.swift
//  miniProject
//
//  Created by Manisha Reddy Narayan on 05/03/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import Parse

class HomeCollectionViewController: UICollectionViewController {
    var imageFiles = [PFFile]()
    var files = [PFObject]()
    var backgroundImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        let cgFloat: CGFloat = 250.0
        let someFloat = Float(cgFloat)
        let itemSize = (self.collectionView?.frame.size.width)! - 20
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0,5,0,5)
        layout.itemSize = CGSize(width: itemSize/2, height: CGFloat(someFloat))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        
        collectionView?.collectionViewLayout = layout
        collectionView?.register(UINib(nibName:"AddMemoryCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "AddCell")
        collectionView?.register(UINib(nibName:"ViewMemoryCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "ViewCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getImages()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getImages() -> Void {
        let query = PFQuery(className: "Memory")
        query.whereKey("userid", equalTo: PFUser.current()?.objectId!)
        query.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil {
                print("OK")
                self.files.removeAll()
                self.files = objects!
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
                
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath) as! AddMemoryCollectionViewCell
            cell.layer.borderWidth = 2.5
            cell.layer.borderColor = UIColor.darkGray.cgColor
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewCell", for: indexPath) as! ViewMemoryCollectionViewCell
            let object = files[indexPath.row]
            var imageFile:PFFile!
            var location:String!
            var title:String!
            var date:String!
            if object["imageFile"] != nil {
                imageFile = object["imageFile"] as! PFFile
                location = object["location"] as! String
                title = object["title"] as! String
                date = object["date"] as! String
                cell.playImage.isHidden = true
            }
            else {
                imageFile = object["thumbnail"] as! PFFile
                location = object["location"] as! String
                title = object["title"] as! String
                date = object["date"] as! String
                cell.playImage.isHidden = false
            }
            imageFile.getDataInBackground(block: { (data, error) in
                if error == nil {
                    if let imageToDispaly = UIImage(data: data!) {
                        cell.imageView.image = imageToDispaly
                        
                    }
                }
            })
            cell.locationLabel.text = location
            cell.titleLabel.text = title
            cell.dateLabel.text = date
            cell.layer.borderWidth = 2.5
            cell.layer.borderColor = UIColor.darkGray.cgColor
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.performSegue(withIdentifier: "CreateMemory", sender: self)
            return
        } else {
            let object = files[indexPath.row]
            var imageFile:PFFile!
            var location:String!
            var title:String!
            var date:String!
            if object["imageFile"] != nil {
                imageFile = object["imageFile"] as! PFFile
                location = object["location"] as! String
                title = object["title"] as! String
                date = object["date"] as! String
                imageFile.getDataInBackground(block: { (data, error) in
                    if error == nil {
                        if let imageToDispaly = UIImage(data: data!) {
                            let viewControllers = self.navigationController!.viewControllers as [UIViewController];
                            for aViewController:UIViewController in viewControllers {
                                if aViewController.isKind(of: PreviewImageViewController.self) {
                                    (aViewController as? PreviewImageViewController)?.image = imageToDispaly
                                    (aViewController as? PreviewImageViewController)?.location = location
                                    (aViewController as? PreviewImageViewController)?.date = date
                                    (aViewController as? PreviewImageViewController)?.title1 = title
                                }
                            }
                        }
                    }
                })
                
                self.performSegue(withIdentifier: "Priviewimage", sender: self)
            }
        }
        
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        PFUser.logOut()
        
        self.performSegue(withIdentifier: "logout", sender: self)
        
    }
}
