//
//  ChooseVideoViewController.swift
//  miniProject
//
//  Created by Manisha Reddy Narayan on 08/03/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary
import Parse
import MediaPlayer
import Foundation
import SystemConfiguration
protocol ChooseVideoViewControllerDelegate {
    func finishPassingVideo(controller: ChooseVideoViewController)
}

class ChooseVideoViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var videoURL: URL?
    let videoPicker = UIImagePickerController()
    var delegate: ChooseVideoViewControllerDelegate?
    @IBOutlet weak var videoDone: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryVideo()
        videoDone.buttonShape()
    }
    
    func galleryVideo()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            
            let videoPicker = UIImagePickerController()
            videoPicker.delegate = self
            videoPicker.sourceType = .photoLibrary
            videoPicker.mediaTypes = [kUTTypeMovie as String]
            self.present(videoPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let memory = PFObject(className:"Memory")
        memory["userid"] = PFUser.current()?.objectId
        videoURL = (info[UIImagePickerControllerMediaURL] as? URL)
        if let url = videoURL {
            let ass = AVAsset(url:url as URL)
            let videoData = NSData(contentsOfFile:(url.relativePath))
            self.videoDone.isHidden = false
            if let videoThumbnail = ass.videoThumbnail{
                let viewControllers = self.navigationController!.viewControllers as [UIViewController];
                for aViewController:UIViewController in viewControllers {
                    if aViewController.isKind(of: CreateMemoryViewController.self) {
                        (aViewController as? CreateMemoryViewController)?.videoThumbnail = videoThumbnail
                        (aViewController as? CreateMemoryViewController)?.video = videoData
                    }
                    
                }
            }
        }
        print("videoURL:\(String(describing: videoURL))")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func videoDoneOnClick(_ sender: Any) {
        delegate?.finishPassingVideo(controller: self)
        
    }
}

extension AVAsset{
    var videoThumbnail:UIImage?{
        let assetImageGenerator = AVAssetImageGenerator(asset: self)
        assetImageGenerator.appliesPreferredTrackTransform = true
        var time = self.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbNail = UIImage.init(cgImage: imageRef)
            print("Video Thumbnail genertated successfuly")
            return thumbNail
            
        } catch {
            print("error getting thumbnail video")
            return nil
        }
        
    }
}



