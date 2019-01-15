//
//  ViewController.swift
//  radiotest02
//
//  Created by Kerolles Roshdi on 12/19/18.
//  Copyright © 2018 Kerolles Roshdi. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class RadioViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var hz64Btn: UIButton!
    @IBOutlet weak var hz128Btn: UIButton!
    @IBOutlet weak var hz192Btn: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextLbl: MarqueeLabel!
    
    @IBOutlet weak var rotorTop: UIImageView!
    @IBOutlet weak var rotorDown: UIImageView!
    
    
    @IBOutlet weak var volumeViewParent: UIView!
    
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var systemSlider = UISlider()
    
    let url64 = "http://broadcast.alkalima.net:8000/alkalima_64"
    let url128 = "http://broadcast.alkalima.net:8000/alkalima_128"
    let url192 = "http://broadcast.alkalima.net:8000/alkalima_192"
    
    
//    http://broadcast.alkalima.net:8000/alkalima_128
//    https://sample-videos.com/audio/mp3/crowd-cheering.mp3
    
    func playFromHTTP(stringUrl : String) {
        guard let url = URL(string: stringUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        self.player.play()
    }
    
    
    
    func playPause() {
        if (self.player.rate != 0 && self.player.error == nil) {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "playBtn"), for: .normal)
            stopCasetteSpin()
        } else if self.player.error == nil {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pauseBtn"), for: .normal)
            startCasetteSpin()
        }
        
    }
    
    func setupNowPlaying(title: String, album: String) {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = album
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            self.playPause()
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            self.playPause()
            return .commandFailed
        }
    }
    
    var casetteIsPlaying: Bool = false
    
    func startCasetteSpin() {
       if  (rotorTop.layer.animationKeys()?.count == nil && !casetteIsPlaying) {
            rotorTop.rotate()
            rotorDown.rotate()
            casetteIsPlaying = true
        
       } else if (rotorTop.layer.animationKeys()?.count != nil && !casetteIsPlaying) {
            rotorTop.resumeAnimation()
            rotorDown.resumeAnimation()
            casetteIsPlaying = true
        }
    }
    
    func stopCasetteSpin() {
        if (rotorTop.layer.animationKeys()?.count != nil && casetteIsPlaying) {
            rotorTop.pauseAnimation()
            rotorDown.pauseAnimation()
            casetteIsPlaying = false
        }
        
            
    }
    
//    set the status bar style to be light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func restartAnimation () {
        debugPrint("trying to resume animation after being in background")
        startCasetteSpin()
    }
    
    @objc func pauseAnimation () {
        debugPrint("trying to pause animation before being in background")
        stopCasetteSpin()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkConnection()
        
         NotificationCenter.default.addObserver(self, selector: #selector(pauseAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(restartAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        volumeViewParent.backgroundColor = UIColor.clear
        let volumeView = MPVolumeView(frame: volumeViewParent.bounds)
        volumeView.setRouteButtonImage(#imageLiteral(resourceName: "louderIcon"), for: .normal)
        let volumeViewSubviews = volumeView.subviews
        for current in volumeViewSubviews {
            if current.isKind(of: UISlider.self) {
                let tempSlider = current as! UISlider
                tempSlider.minimumTrackTintColor = #colorLiteral(red: 0.4530203342, green: 0.7235316634, blue: 0.9999685884, alpha: 1)
                tempSlider.maximumTrackTintColor = #colorLiteral(red: 0.2461777925, green: 0.2772988677, blue: 0.2858988643, alpha: 1)
                tempSlider.maximumValueImage = #imageLiteral(resourceName: "louderIcon")
                tempSlider.minimumValueImage = #imageLiteral(resourceName: "quieterIcon")
            }
        }
        volumeViewParent.addSubview(volumeView)
        
//         get all fonts available in the app
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
        
        self.nextLbl.innerText = "You Are OFFLINE"
        self.nextLbl.innerSize = 27
        self.nextLbl.innerColor = UIColor.white
        
        playFromHTTP(stringUrl: url128)
        setupRemoteTransportControls()
        
        getLiveInfo { (currentTrack ,nextTrack) in
            DispatchQueue.main.async {
                self.nextLbl.innerText = "Now Playing: \(currentTrack.htmlDecoded)     Next: \(nextTrack.htmlDecoded)"
                self.setupNowPlaying(title: nextTrack.htmlDecoded, album: "Al Kalima Radio")
            }
        }
        
    }
    

    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        playPause()
    }
    
    
    @IBAction func hz64BtnPressed(_ sender: Any) {
        if hz64Btn.currentImage == #imageLiteral(resourceName: "64hz") {
            hz64Btn.setImage(#imageLiteral(resourceName: "64hzPressed"), for: .normal)
            hz128Btn.setImage(#imageLiteral(resourceName: "128hz"), for: .normal)
            hz192Btn.setImage(#imageLiteral(resourceName: "192hz"), for: .normal)
            
            playFromHTTP(stringUrl: url64)
            playPauseButton.setImage(#imageLiteral(resourceName: "playBtn"), for: .normal)
            
            if (self.player.rate != 0 && self.player.error == nil) {
                stopCasetteSpin()
            }
            
        }
    }
    
    @IBAction func hz128BtnPressed(_ sender: Any) {
        if hz128Btn.currentImage == #imageLiteral(resourceName: "128hz") {
            hz64Btn.setImage(#imageLiteral(resourceName: "64hz"), for: .normal)
            hz128Btn.setImage(#imageLiteral(resourceName: "128hzPressed"), for: .normal)
            hz192Btn.setImage(#imageLiteral(resourceName: "192hz"), for: .normal)
            
            playFromHTTP(stringUrl: url128)
            playPauseButton.setImage(#imageLiteral(resourceName: "playBtn"), for: .normal)
            if (self.player.rate != 0 && self.player.error == nil) {
                stopCasetteSpin()
            }
        }
    }
    
    @IBAction func hz192BtnPressed(_ sender: Any) {
        if hz192Btn.currentImage == #imageLiteral(resourceName: "192hz") {
            hz64Btn.setImage(#imageLiteral(resourceName: "64hz"), for: .normal)
            hz128Btn.setImage(#imageLiteral(resourceName: "128hz"), for: .normal)
            hz192Btn.setImage(#imageLiteral(resourceName: "192hzPressed"), for: .normal)
            
            playFromHTTP(stringUrl: url192)
            playPauseButton.setImage(#imageLiteral(resourceName: "playBtn"), for: .normal)
            if (self.player.rate != 0 && self.player.error == nil) {
                stopCasetteSpin()
            }
        }
    }
    
    
}

