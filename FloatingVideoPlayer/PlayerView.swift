//
//  PlayerView.swift
//  FloatingVideoPlayer
//
//  Created by 任岐鸣 on 2016/10/28.
//  Copyright © 2016年 Ned. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerView: UIView {
    
    lazy var player:AVPlayer = {
        let player = AVPlayer.init(playerItem: self.playerItem)
        return player
    }()
    
    lazy var playerItem:AVPlayerItem = {
        let playerItem = AVPlayerItem.init(url: self.playUrl)
        return playerItem
    }()
    
    var playUrl:URL = URL.init(string: "http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4")!
    
    lazy var progressSlider:UISlider = {
        let slider = UISlider.init()
        return slider
    }()
    
    lazy var btnPlay:UIButton = {
        let button = UIButton.init()
        return button
    }()
    
    lazy var btnPrev:UIButton = {
        let button = UIButton.init()
        return button
    }()
    
    lazy var btnNext:UIButton = {
        let button = UIButton.init()
        return button
    }()
    
    lazy var playerLayer:AVPlayerLayer = {
        let playerLayer = AVPlayerLayer.init(player: self.player)
        playerLayer.frame = CGRect.init(x: 20, y: 20, width: 200, height: 100)
        playerLayer.backgroundColor = UIColor.black.cgColor
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        return playerLayer
    }()

    init(url:URL) {
        super.init(frame: CGRect.zero)
        playUrl = url
//        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        commonInit()
    }
    
    func setPlayer() {
        layer.addSublayer(playerLayer)
        progressSlider.value = 0
        player.volume = 1
        player.play()
    }
}
