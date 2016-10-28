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
    var videoView = UIView.init()
    var tableView = UIView.init()
    var panGesture = UIPanGestureRecognizer.init()
    
    var transitionPercentage = 0.0
    var currentState = viewState.fullScreen
    
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
            if pan.state == .began {
                weakSelf?.transitionPercentage = 0
            } else if pan.state == .changed {
                
                weakSelf?.transitionPercentage = fabs(Double(pan.translation(in: weakSelf).y)/Double((weakSelf?.tableView.frame.height)!))
                
//                weakSelf?.transitionPercentage = (weakSelf?.frame.origin.y)! / self.frame.height
                
//                print(weakSelf?.transitionPercentage)
                switch (weakSelf?.currentState)! {
                case .floatingWindow:
                    if pan.translation(in: weakSelf).y < 0 {
                        weakSelf?.videoView.snp.remakeConstraints { (make) in
                            make.bottom.equalToSuperview()
                            make.width.equalToSuperview().multipliedBy((weakSelf?.transitionPercentage)!/2+0.5)
                            make.right.equalToSuperview()
                            make.height.equalToSuperview().multipliedBy((weakSelf?.transitionPercentage)!/2+0.5)
                        }
                        weakSelf?.backgroundView.alpha = CGFloat((weakSelf?.transitionPercentage)!)
                        weakSelf?.tableView.alpha = CGFloat((weakSelf?.transitionPercentage)!)
                        weakSelf?.frame.origin.y = (weakSelf?.tableView.frame.height)!-abs(pan.translation(in: weakSelf).y)
                    }
                case .fullScreen:
                    if pan.translation(in: weakSelf).y > 0 {
                        weakSelf?.videoView.snp.remakeConstraints { (make) in
                            make.bottom.equalToSuperview()
                            make.width.equalToSuperview().multipliedBy(1 - (weakSelf?.transitionPercentage)!/2)
                            make.right.equalToSuperview()
                            make.height.equalToSuperview().multipliedBy(1 - (weakSelf?.transitionPercentage)!/2)
                        }
                        weakSelf?.backgroundView.alpha = 1 - CGFloat((weakSelf?.transitionPercentage)!)
                        weakSelf?.tableView.alpha = 1 - CGFloat((weakSelf?.transitionPercentage)!)
                        weakSelf?.frame.origin.y = pan.translation(in: weakSelf).y
                    }
                }
            } else if pan.state == .ended {
                if (weakSelf?.transitionPercentage)! >= 0.3 {
                    weakSelf?.animateToEnd()
                } else {
                    weakSelf?.animateToStart()
                }
            }
        }
        backgroundView.backgroundColor = UIColor.black
        addSubview(videoBackView)
        videoBackView.addSubview(videoView)
        addSubview(tableView)
        videoView.backgroundColor = UIColor.yellow
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
//                print((weakSelf?.frame.height)!)
//                print((weakSelf?.videoBackView.frame.height)!)
                print((weakSelf?.frame.height)!)
                weakSelf?.currentState = .floatingWindow
            }
            weakSelf?.layoutIfNeeded()
            }, completion: {
                Bool in
//                if (weakSelf?.currentState)! == .floatingWindow {
//                    UIView.animate(withDuration: 0.3, animations: { 
//                        weakSelf?.frame.origin.y = 568
//                    })
//                }
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
            weakSelf?.layoutIfNeeded()
            }, completion: nil)
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
    func addPanGesture(action: ((UIPanGestureRecognizer) -> ())?) {
        let pan = BlockPan(action: action)
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
    }
}

class BlockPan: UIPanGestureRecognizer {
    private var panAction: ((UIPanGestureRecognizer) -> Void)?
    
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    public convenience init (action: ((UIPanGestureRecognizer) -> Void)?) {
        self.init()
        self.panAction = action
        self.addTarget(self, action: #selector(BlockPan.didPan(_:)))
    }
    
    open func didPan (_ pan: UIPanGestureRecognizer) {
        panAction? (pan)
    }
}
