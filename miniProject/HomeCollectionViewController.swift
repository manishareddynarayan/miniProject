//
//  HomeCollectionViewController.swift
//  miniProject
//
//  Created by Manisha Reddy Narayan on 05/03/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import Parse

class HomeCollectionViewController: UICollectionViewController,UISearchBarDelegate{
    var searchController = UISearchController()
    var imageFiles = [PFFile]()
    var files = [PFObject]()
    var backgroundImage = UIImage()
    var searchElements = [""]
    var isSearch = false
    var searchedArray = [PFObject]()
    
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
                self.files = objects!.reversed()
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(isSearch) {
            return searchedArray.count
        }
        return (files.count + 1)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewCell", for: indexPath) as! ViewMemoryCollectionViewCell
        if(isSearch) {
            let object = searchedArray[indexPath.row]
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
        else {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath) as! AddMemoryCollectionViewCell
                cell.layer.borderWidth = 2.5
                cell.layer.borderColor = UIColor.darkGray.cgColor
                return cell
            } else {
                let object = files[indexPath.row - 1]
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
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader", for: indexPath)
        return header
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(isSearch) {
            let object = searchedArray[indexPath.row]
            var imageFile:PFFile!
            var videoFile:PFFile!
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
            } else {
                videoFile = object["videoFile"] as! PFFile
                if (videoFile) != nil {
                    self.performSegue(withIdentifier: "previewVideo", sender: indexPath)
                }
            }
        }
        else{
            if indexPath.row == 0{
                self.performSegue(withIdentifier: "CreateMemory", sender: self)
                return
            } else {
                let object = files[indexPath.row - 1]
                var imageFile:PFFile!
                var videoFile:PFFile!
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
                } else {
                    videoFile = object["videoFile"] as! PFFile
                    if (videoFile) != nil {
                        self.performSegue(withIdentifier: "previewVideo", sender: indexPath)
                    }
                }
                
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewVideo" {
            let videoSender = sender as! IndexPath
            let object = files[videoSender.row - 1]
            var videoFile:PFFile!
            var location:String!
            var title:String!
            var date:String!
            videoFile = object["videoFile"] as! PFFile
            if object["videoFile"] != nil {
                location = object["location"] as! String
                title = object["title"] as! String
                date = object["date"] as! String
                if let nextViewController = segue.destination as? PreviewVideoViewController{
                    nextViewController.videoFile = videoFile
                    nextViewController.location = location
                    nextViewController.date = date
                    nextViewController.videoTitle = title
                }
            }
        }
    }
    @IBAction func search(_ sender: Any) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        //        searchController.searchBar.text = searchText
        
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
        searchController.searchBar.backgroundColor = UIColor.black
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = true;
        self.collectionView?.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedArray = self.files.filter({ (object) -> Bool in
            let location1:NSString = object["location"] as! NSString
            let title:NSString = object["title"] as! NSString
            let range1 = location1.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let range2 = title.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return (range1.location != NSNotFound ||  range2.location != NSNotFound)
        })
        if(self.searchedArray.count == 0){
            self.isSearch = false;
        } else {
            self.isSearch = true;
        }
        self.collectionView?.reloadData()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        PFUser.logOut()
        self.performSegue(withIdentifier: "logout", sender: self)
    }
}
