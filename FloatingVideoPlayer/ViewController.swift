//
//  ViewController.swift
//  FloatingVideoPlayer
//
//  Created by 任岐鸣 on 2016/10/27.
//  Copyright © 2016年 Ned. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let window = UIApplication.shared.keyWindow!
        let floatingView = FloatingView.sharedInstance
        floatingView.frame = self.view.frame
        window.addSubview(floatingView)
        floatingView.videoView.setPlayer()
    }
    
    func printSomething() {
        print("click!")
    }
    
    @IBAction func showAnotherVC(_ sender: AnyObject) {
        let vc = UIViewController.init()
        vc.view.backgroundColor = .blue
        present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

