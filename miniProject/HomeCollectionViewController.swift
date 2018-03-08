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
                if let posts = objects {
                    for object in posts {
                        print("IN FOR")
                        if object["imageFile"] != nil {
                            self.imageFiles.append(object["imageFile"] as! PFFile)
                            
                        }
                        if object["thumbnail"] != nil {
                            self.imageFiles.append(object["thumbnail"] as! PFFile)
                            
                        }
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageFiles.count
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
            let query = PFQuery(className: "Memory")
            
            query.whereKey("userid", equalTo: PFUser.current()?.objectId!)
            
            query.findObjectsInBackground{ (objects, error) -> Void in
                if error == nil {
                    print("OK")
                    if let posts = objects {
                        for object in posts {
                            if object["type"] != nil {
                                self.imageFiles[indexPath.row].getDataInBackground { (data, error) in
                                    if let imageData = data {
                                        if let imageToDispaly = UIImage(data: imageData) {
                                            cell.imageView.image = imageToDispaly
                                        }
                                    }
                                    
                                }
                                
                            }
                            self.imageFiles[indexPath.row].getDataInBackground { (data, error) in
                                if let imageData = data {
                                    if let imageToDispaly = UIImage(data: imageData) {
                                        cell.imageView.image = imageToDispaly
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            cell.layer.borderWidth = 2.5
            cell.layer.borderColor = UIColor.darkGray.cgColor
            return cell
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.performSegue(withIdentifier: "CreateMemory", sender: self)
            return
        }
        
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        PFUser.logOut()
        
        self.performSegue(withIdentifier: "logout", sender: self)
        
    }
}
