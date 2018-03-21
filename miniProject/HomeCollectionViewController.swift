//
//  HomeCollectionViewController.swift
//  miniProject
//  Created by Manisha Reddy Narayan on 05/03/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
import UIKit
import Parse
class HomeCollectionViewController: UICollectionViewController,UISearchBarDelegate,ViewMemoryCollectionViewCellDelegate{
    var searchController = UISearchController()
    var imageFiles = [PFFile]()
    var memories = [PFObject]()
    var backgroundImage = UIImage()
    var searchElements = [""]
    var isSearch = false
    var searchedArray = [PFObject]()
    var cache:NSCache<AnyObject, AnyObject>!
    var delegate: ViewMemoryCollectionViewCellDelegate?
    @IBOutlet weak var searchbutton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
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
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionView?.register(UINib(nibName:"AddMemoryCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "AddCell")
        collectionView?.register(UINib(nibName:"ViewMemoryCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "ViewCell")
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.tintColor = UIColor.black
        self.cache = NSCache()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getImages()
    }
    func getImages() -> Void {
        let query = PFQuery(className: "Memory")
        query.whereKey("userid", equalTo: PFUser.current()?.objectId! as Any)
        query.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil {
                print("OK")
                self.memories = objects!.reversed()
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    self.collectionView?.collectionViewLayout.invalidateLayout()
                }
            }else{
                print("error")
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(isSearch) {
            return searchedArray.count
        }
        return (memories.count + 1)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewCell", for: indexPath) as! ViewMemoryCollectionViewCell
        if(isSearch) {
            let object = searchedArray[indexPath.row]
            var imageFile:PFFile!
            var location:String!
            var title:String!
            var date:String!
            let formatter = DateFormatter()

//            let convertedDate = formatter.date(from: date)
//            formatter.timeZone = TimeZone(identifier: "Local")
//            let UTCDate = formatter.string(from: convertedDate!)

            location = object["location"] as? String
            if((location == nil)){
                location = ""
            }
            if object["imageFile"] != nil {
                imageFile = object["imageFile"] as! PFFile
                title = object["title"] as! String
                date = object["date"] as! String
                cell.playImage.isHidden = true
            }
            else {
                imageFile = object["thumbnail"] as! PFFile
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
            let convertedDate = formatter.date(from: date)
            formatter.timeZone = TimeZone(identifier: "Local")
            let UTCDate = formatter.string(from: convertedDate!)
            cell.dateLabel.text = UTCDate
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
                let object = memories[indexPath.row - 1]
                var imageFile:PFFile!
                var location:String?
                var title:String!
                var date:String!
                var objectId:String?
                let formatter = DateFormatter()

                location = object["location"] as? String
                if((location == nil)){
                    location = ""
                }
                if object["imageFile"] != nil {
                    imageFile = object["imageFile"] as! PFFile
                    title = object["title"] as! String
                    date = object["date"] as! String
                    cell.playImage.isHidden = true
                }
                else {
                    imageFile = object["thumbnail"] as! PFFile
                    title = object["title"] as! String
                    date = object["date"] as! String
                    cell.playImage.isHidden = false
                }
                objectId = object.objectId
                if ((objectId == nil)){
                    print("no object")
                }
                if (self.cache.object(forKey: objectId as AnyObject) != nil){
                    print("Cached image used, no need to download it")
                    cell.imageView?.image = self.cache.object(forKey: objectId as AnyObject) as? UIImage
                } else {
                    imageFile.getDataInBackground(block: { (data, error) in
                        if error == nil {
                            if let imageToDispaly = UIImage(data: data!) {
                                DispatchQueue.main.async{
                                    cell.imageView.image = imageToDispaly
                                    self.cache.setObject(imageToDispaly, forKey: objectId  as AnyObject)
                                }
                                
                            }
                            
                        }
                    })
                }
                cell.locationLabel.text = location
                cell.titleLabel.text = title
                formatter.dateFormat = "dd-MM-yyy\nH:mm:ss"
                let convertedDate = formatter.date(from: date)
                formatter.timeZone = TimeZone.current
                let UTCDate = formatter.string(from: convertedDate!)
                cell.dateLabel.text = UTCDate
                cell.layer.borderWidth = 2.5
                cell.layer.borderColor = UIColor.darkGray.cgColor
                cell.deletebtn.isHidden = !isEditing
                cell.delegate = self
                return cell
            }
        }
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
                location = object["location"] as? String
                if((location == nil)){
                    location = ""
                }
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
                let object = memories[indexPath.row - 1]
                var imageFile:PFFile!
                var videoFile:PFFile!
                var location:String!
                var title:String!
                var date:String!
                if object["imageFile"] != nil {
                    imageFile = object["imageFile"] as! PFFile
                    location = object["location"] as? String
                    if((location == nil)){
                        location = ""
                    }
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
            let object = memories[videoSender.row - 1]
            var videoFile:PFFile!
            var location:String!
            var title:String!
            var date:String!
            videoFile = object["videoFile"] as! PFFile
            if object["videoFile"] != nil {
                location = object["location"] as? String
                if((location == nil)){
                    location = ""
                }
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
    func deleteMemory(cell: ViewMemoryCollectionViewCell) {
        if let indexPath = collectionView?.indexPath(for: cell) {
            let ac = UIAlertController(title: "Warning", message: "Are you sure you want to delete it?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
                (action:UIAlertAction!) -> Void in
                self.memories.remove(at: (indexPath.row))
                self.memories[indexPath.row - 1].deleteInBackground()
                self.collectionView?.deleteItems(at: [indexPath])
                self.collectionView?.reloadData()
                self.collectionView?.collectionViewLayout.invalidateLayout() }))
            present(ac, animated: true, completion: nil)
        }
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        searchbutton.isEnabled = !editing
        logoutButton.isEnabled = !editing
        if let indexPaths = collectionView?.indexPathsForVisibleItems{
            for indexPath in indexPaths {
                if let cell = collectionView?.cellForItem(at: indexPath) as? ViewMemoryCollectionViewCell {
                    if  cell.isEditing == editing {
                        cell.alpha = 1
                        cell.deletebtn.isHidden = true
                    } else {
                        cell.isEditing = false
                        cell.deletebtn.isHidden = false
                        cell.alpha = 0.7
                    }
                }
                
            }
        }
    }
    @IBAction func search(_ sender: Any) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
        searchController.searchBar.backgroundColor = UIColor.black
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
        self.collectionView?.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.collectionView?.restore()
        searchBar.resignFirstResponder()
        isSearch = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedArray = self.memories.filter({ (object) -> Bool in
            var location:String!
            if((location != nil)){
                location = object["location"] as? String
            }else{
                location = ""
            }
            let location1:NSString = location! as NSString
            let title:NSString = object["title"] as! NSString
            let range1 = location1.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let range2 = title.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return (range1.location != NSNotFound ||  range2.location != NSNotFound)
        })
        if(self.searchedArray.count == 0){
            print("no items")
            self.collectionView?.setEmptyMessage("Nothing to show :(")
            self.collectionView?.reloadData()
        } else {
            self.collectionView?.restore()
            self.isSearch = true
            self.collectionView?.reloadData()
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        PFUser.logOut()
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginvc") as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }
}
extension UICollectionView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 30)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }
    func restore() {
        self.backgroundView = nil
    }
}
