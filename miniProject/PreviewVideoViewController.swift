//
//  PreviewVideoViewController.swift
//  miniProject
//
//  Created by Manisha Reddy Narayan on 12/03/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Parse
import Photos

class PreviewVideoViewController: UIViewController,AVPlayerViewControllerDelegate {
    var avPlayer: AVPlayer?
    var item: AVPlayerItem?
    var videoData:Data?
    var videoFile: PFFile?
    var location:String!
    var videoTitle:String!
    var date:String!
    var avPlayerController:AVPlayerViewController = AVPlayerViewController()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    private var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avPlayerController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/2)
        avPlayerController.showsPlaybackControls = true
        avPlayerController.delegate = self
        self.view.addSubview(avPlayerController.view)
        playVideo(videoFile: videoFile!)
    }
    
    func playVideo(videoFile:PFFile){
        let url = URL.init(string: videoFile.url!)
        let asset  = AVAsset(url: url!)
        let playerItem = AVPlayerItem(asset: asset)
        self.avPlayer = AVPlayer(playerItem: playerItem)
        avPlayerController.player = avPlayer
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
        self.avPlayer!.play()
    }
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = videoTitle
        locationLabel.text = location
        dateLabel.text = date
        
    }
    func playerDidReachEndNotificationHandler(notif: Notification){
        print(notif.description)
    }
    func play(){
        self.avPlayer!.play()
    }
    deinit {
        avPlayerController.player = nil
    }
    
    @IBAction func share(_ sender: Any) {
        let activityVc = UIActivityViewController(activityItems: [self.videoFile as Any], applicationActivities: nil)
        activityVc.popoverPresentationController?.sourceView = self.view
        self.present(activityVc, animated: true, completion: nil)
    }
}

