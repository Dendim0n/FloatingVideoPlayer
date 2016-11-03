//
//  ViewController.swift
//  FloatingVideoPlayer
//
//  Created by 任岐鸣 on 2016/10/27.
//  Copyright © 2016年 Ned. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let urlArray = ["http://123.134.67.201:80/play/BEDF14F6FF4FF604DCCB053EEE20536EB33EFC37.mp4","http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let vc = ViewController.init()
        vc.view.backgroundColor = .blue
        present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = urlArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FloatingView.sharedInstance.videoView.playUrl(url: URL.init(string: urlArray[indexPath.row])!)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlArray.count
    }
}

