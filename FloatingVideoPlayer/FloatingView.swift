//
//  FloatingView.swift
//  FloatingVideoPlayer
//
//  Created by 任岐鸣 on 2016/10/27.
//  Copyright © 2016年 Ned. All rights reserved.
//

import UIKit

class FloatingView: UIView {
    
    static let sharedInstance = FloatingView()
    
    enum viewState {
        case fullScreen
        case floatingWindow
    }
    
    var videoBackView = VideoBackground.init()
    var backgroundView = UIView.init()
    var videoView = PlayerView.init(url: URL.init(string: "http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4")!)
    var tableView = UIView.init()
    var panGesture = BlockPan()
    
    var transitionPercentage = 0.0
    var currentState = viewState.fullScreen
    
    var displayLink = CADisplayLink()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func commonInit() {
        weak var weakSelf = self
        videoView.addPanGesture { (pan) in
            pan.tag = 6666
            weakSelf?.panGesture = pan
            if pan.state == .began {
                weakSelf?.videoView.hideControlObjects()
                weakSelf?.transitionPercentage = 0
                weakSelf?.displayLink = CADisplayLink.init(target: self, selector: #selector(weakSelf?.updateViews))
                weakSelf?.displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
            } else if pan.state == .ended {
                weakSelf?.displayLink.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
                if (weakSelf?.transitionPercentage)! >= 0.3 {
                    weakSelf?.animateToEnd()
                } else {
                    weakSelf?.animateToStart()
                }
            }
        }
        videoView.addTapGesture { (tap) in
            if weakSelf?.currentState == .floatingWindow {
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: { 
                    weakSelf?.videoView.snp.remakeConstraints { (make) in
                        make.bottom.equalToSuperview()
                        make.width.equalToSuperview()
                        make.right.equalToSuperview()
                        make.height.equalToSuperview()
                    }
                    weakSelf?.backgroundView.alpha = 1
                    weakSelf?.tableView.alpha = 1
                    weakSelf?.frame.origin.y = 0
                    weakSelf?.currentState = .fullScreen
                    weakSelf?.layoutIfNeeded()
                }, completion: nil)
            } else {
                if (weakSelf?.videoView.panelVisible)! {
                    weakSelf?.videoView.hideControlObjects()
                } else {
                    weakSelf?.videoView.showControlObjects()
                }
//                weakSelf?.videoView.panelVisible = !(weakSelf?.videoView.panelVisible)!
            }
        }
        backgroundView.backgroundColor = UIColor.black
        addSubview(videoBackView)
        videoBackView.addSubview(videoView)
        addSubview(tableView)
//        videoView.backgroundColor = UIColor.yellow
        tableView.backgroundColor = UIColor.darkGray
        videoBackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(videoView.snp.width).multipliedBy(0.75)
        }
        videoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(videoView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    func animateToEnd() {
        print("to end")
        weak var weakSelf = self
        //        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            switch (weakSelf?.currentState)! {
            case .floatingWindow:
                weakSelf?.videoView.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview()
                    make.width.equalToSuperview()
                    make.right.equalToSuperview()
                    make.height.equalToSuperview()
                }
                weakSelf?.backgroundView.alpha = 1
                weakSelf?.tableView.alpha = 1
                weakSelf?.frame.origin.y = 0
                weakSelf?.currentState = .fullScreen
            case .fullScreen:
                weakSelf?.videoView.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(0.5)
                    make.right.equalToSuperview()
                    make.height.equalToSuperview().multipliedBy(0.5)
                }
                weakSelf?.backgroundView.alpha = 0
                weakSelf?.tableView.alpha = 0
                weakSelf?.frame.origin.y = (weakSelf?.tableView.frame.height)!
                print((weakSelf?.frame.height)!)
                weakSelf?.currentState = .floatingWindow
            }
            self.videoView.playerLayer.frame = self.videoView.bounds
            weakSelf?.layoutIfNeeded()
            }, completion: {
                Bool in
                //Need to fix the frame problem!!
                if (weakSelf?.currentState)! == .floatingWindow {
                    UIView.animate(withDuration: 0.3, animations: { 
                        weakSelf?.frame.origin.y = (weakSelf?.tableView.frame.height)!
                    })
                }
                print(weakSelf?.frame.origin.y)
                print(weakSelf?.tableView.frame.height)
        })
    }
    func animateToStart() {
        print("to start~")
        weak var weakSelf = self
        weakSelf?.videoView.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            switch (weakSelf?.currentState)! {
            case .floatingWindow:
                
                weakSelf?.videoView.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(0.5)
                    make.right.equalToSuperview()
                    make.height.equalToSuperview().multipliedBy(0.5)
                }
                weakSelf?.backgroundView.alpha = 0
                weakSelf?.tableView.alpha = 0
                weakSelf?.frame.origin.y = (weakSelf?.tableView.frame.height)!
                
            case .fullScreen:
                weakSelf?.videoView.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview()
                    make.width.equalToSuperview()
                    make.right.equalToSuperview()
                    make.height.equalToSuperview()
                }
                weakSelf?.backgroundView.alpha = 1
                weakSelf?.tableView.alpha = 1
                weakSelf?.frame.origin.y = 0
                
            }
            self.videoView.playerLayer.frame = self.videoView.bounds
            weakSelf?.layoutIfNeeded()
            }, completion: {
                Bool in
                if (weakSelf?.currentState)! == .floatingWindow {
                    UIView.animate(withDuration: 0.3, animations: {
                        weakSelf?.frame.origin.y = (weakSelf?.tableView.frame.height)!
                    })
                }
        })
    }
    
    func updateViews() {
        
        transitionPercentage = fabs(Double(panGesture.translation(in: self).y)/Double(tableView.frame.height))
        
        //                weakSelf?.transitionPercentage = (weakSelf?.frame.origin.y)! / self.frame.height
        
        //                print(weakSelf?.transitionPercentage)
        switch currentState {
        case .floatingWindow:
            if panGesture.translation(in: self).y < 0 {
                videoView.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(min(1,transitionPercentage/2+0.5))
                    make.right.equalToSuperview()
                    make.height.equalToSuperview().multipliedBy(min(1,transitionPercentage/2+0.5))
                }
                backgroundView.alpha = CGFloat(transitionPercentage)
                tableView.alpha = CGFloat(transitionPercentage)
                frame.origin.y = max(0,tableView.frame.height)-abs(panGesture.translation(in: self).y)
            }
        case .fullScreen:
            if panGesture.translation(in: self).y > 0 {
                videoView.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(1 - transitionPercentage/2)
                    make.right.equalToSuperview()
                    make.height.equalToSuperview().multipliedBy(1 - transitionPercentage/2)
                }
                backgroundView.alpha = 1 - CGFloat(transitionPercentage)
                tableView.alpha = 1 - CGFloat(transitionPercentage)
                frame.origin.y = panGesture.translation(in: self).y
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            
        } else if keyPath == "loadedTimeRanges" {
            
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        print("hit test MainBackground")
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        } else {
            return hitView
        }
    }
}

class VideoBackground:UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        print("hit test VideoBackground")
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        } else {
            return hitView
        }
    }
    
    
}

extension UIView {
    func addPanGesture(action: ((BlockPan) -> ())?) {
        let pan = BlockPan(action: action)
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
    }
    func addTapGesture(tapNumber: Int = 1, action: ((BlockTap) -> ())?) {
        let tap = BlockTap(tapCount: tapNumber, fingerCount: 1, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}

class BlockPan: UIPanGestureRecognizer {
    
    var tag = 0
    
    private var panAction: ((BlockPan) -> Void)?
    
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    public convenience init (action: ((BlockPan) -> Void)?) {
        self.init()
        self.panAction = action
        self.addTarget(self, action: #selector(BlockPan.didPan(_:)))
    }
    
    open func didPan (_ pan: BlockPan) {
        panAction? (pan)
    }
}
class BlockTap: UITapGestureRecognizer {
    private var tapAction: ((BlockTap) -> Void)?
    
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    public convenience init (
        tapCount: Int = 1,
        fingerCount: Int = 1,
        action: ((BlockTap) -> Void)?) {
        self.init()
        self.numberOfTapsRequired = tapCount
        
        #if os(iOS)
            
            self.numberOfTouchesRequired = fingerCount
            
        #endif
        
        self.tapAction = action
        self.addTarget(self, action: #selector(BlockTap.didTap(_:)))
    }
    
    open func didTap (_ tap: BlockTap) {
        tapAction? (tap)
    }
}
