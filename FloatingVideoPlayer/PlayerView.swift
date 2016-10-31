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
    
    var playbackTimeObserver:Any?
    
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
    
    lazy var progressView:UIProgressView = {
        let progress = UIProgressView()
        return progress
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
        playerLayer.backgroundColor = UIColor.black.cgColor
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        return playerLayer
    }()
    
    init(url:URL) {
        super.init(frame: CGRect.zero)
        playUrl = url
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setPlayer() {
        
        layer.addSublayer(playerLayer)
        progressSlider.value = 0
        player.volume = 0.1
        player.play()
        
        addSubview(btnNext)
        addSubview(btnPlay)
        addSubview(btnPrev)
        addSubview(progressView)
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
        progressView.snp.makeConstraints { (make) in
            make.centerY.equalTo(progressSlider)
            make.left.equalTo(progressSlider)
            make.right.equalTo(progressSlider)
        }
    }
    
    func showControlObjects() {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.btnPlay.alpha = 1
            self.btnPrev.alpha = 1
            self.btnNext.alpha = 1
            self.progressSlider.alpha = 1
            self.progressView.alpha = 1
        }, completion: nil)
    }
    
    func hideControlObjects() {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.btnPlay.alpha = 0
            self.btnPrev.alpha = 0
            self.btnNext.alpha = 0
            self.progressSlider.alpha = 0
            self.progressView.alpha = 0
        }, completion: nil)
    }
    
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer.frame = self.bounds
    }
    
    func monitoringPlayback(_ playerItem:AVPlayerItem) {
        weak var weakSelf = self
        playbackTimeObserver = player.addPeriodicTimeObserver(forInterval: CMTime.init(seconds: 1, preferredTimescale: 1), queue: nil, using: {
            time in
            let currentSecond = Int(playerItem.currentTime().value)/Int(playerItem.currentTime().timescale)
            weakSelf!.progressSlider.setValue(Float(currentSecond), animated: true)
        })
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let playerItem = object as! AVPlayerItem
        if keyPath == "status" {
            if playerItem.status == .readyToPlay {
                //                NSLog("AVPlayerStatusReadyToPlay");
                //                self.stateButton.enabled = YES;
                let duration = self.playerItem.duration;// 获取视频总长度
                let totalSecond = Int(playerItem.duration.value) / Int(playerItem.duration.timescale)// 转换成秒
                //                let totalTime = convertTime(totalSecond)// 转换成播放时间
                customVideoSlider(duration)// 自定义UISlider外观
                //                NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
                monitoringPlayback(self.playerItem)// 监听播放状态
            } else if playerItem.status == .failed {
                //                NSLog(@"AVPlayerStatusFailed");
            }
        } else if keyPath == "loadedTimeRanges" {
            let timeInterval = availableDuration()// 计算缓冲进度
            //            NSLog(@"Time Interval:%f",timeInterval);
            let duration = self.playerItem.duration;
            let totalDuration = CMTimeGetSeconds(duration)
            
            progressView.setProgress(Float(timeInterval)/Float(totalDuration), animated: true)
        }
        
    }
    
    func customVideoSlider(_ duration:CMTime) {
        progressSlider.maximumValue = Float(CMTimeGetSeconds(duration));
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 1, height: 1), false, 0.0)
        let transparentImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        progressSlider.setMinimumTrackImage(transparentImage, for: .normal)
        progressSlider.setMaximumTrackImage(transparentImage, for: .normal)
    }
    
    
    func availableDuration() -> TimeInterval {
        let loadedTimeRanges = player.currentItem?.loadedTimeRanges
        let timeRange = loadedTimeRanges?.first?.timeRangeValue// 获取缓冲区域
        let startSeconds = CMTimeGetSeconds((timeRange?.start)!);
        let durationSeconds = CMTimeGetSeconds((timeRange?.duration)!);
        let result = startSeconds + durationSeconds;// 计算缓冲总进度
        return result;
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
