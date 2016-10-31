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
    
    var isPlaying = true
    
    lazy var player:AVPlayer = {
        let player = AVPlayer.init(playerItem: self.playerItem)
        return player
    }()
    
    lazy var playerItem:AVPlayerItem = {
        let playerItem:AVPlayerItem = AVPlayerItem.init(url: self.playUrl)
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playDidEnd), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        return playerItem
    }()
    
    var playUrl:URL = URL.init(string: "http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4")!
    
    lazy var progressSlider:UISlider = {
        let slider = UISlider.init()
        return slider
    }()
    
    lazy var btnPlay:UIButton = {
        let button = UIButton.init()
        button.backgroundColor = .yellow
        button.addTarget(self, action: #selector(goPlay), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var btnPrev:UIButton = {
        let button = UIButton.init()
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(goPrev), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var btnNext:UIButton = {
        let button = UIButton.init()
        button.backgroundColor = .purple
        button.addTarget(self, action: #selector(goNext), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var playerLayer:AVPlayerLayer = {
        let playerLayer = AVPlayerLayer.init(player: self.player)
//        playerLayer.frame = CGRect.init(x: 0, y: 0, width: 200, height: 100)
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
        player.volume = 0.1
        player.play()
        
        addSubview(btnNext)
        addSubview(btnPlay)
        addSubview(btnPrev)
        addSubview(progressSlider)
        btnPlay.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4)
            make.width.equalTo(btnPrev.snp.height)
        }
        btnPrev.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(btnPlay).multipliedBy(0.9)
            make.width.equalTo(btnPlay.snp.height).multipliedBy(0.9)
            make.right.equalTo(btnPlay.snp.left).offset(-25)
        }
        btnNext.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(btnPrev)
            make.width.equalTo(btnPrev.snp.height)
            make.left.equalTo(btnPlay.snp.right).offset(25)
        }
        progressSlider.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    func showControlObjects() {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.btnPlay.alpha = 1
            self.btnPrev.alpha = 1
            self.btnNext.alpha = 1
            self.progressSlider.alpha = 1
        }, completion: nil)
    }
    
    func hideControlObjects() {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.btnPlay.alpha = 0
            self.btnPrev.alpha = 0
            self.btnNext.alpha = 0
            self.progressSlider.alpha = 0
        }, completion: nil)
    }
    
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer.frame = self.bounds
    }
    
    func goPlay() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying = !isPlaying
    }
    func goPrev() {
        
    }
    func goNext() {
        
    }
    func playDidEnd() {
    
    }
}
