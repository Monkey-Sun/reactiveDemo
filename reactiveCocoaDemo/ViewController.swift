//
//  ViewController.swift
//  reactiveCocoaDemo
//
//  Created by 孙俊祥 on 2017/8/15.
//  Copyright © 2017年 dist. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class ViewController: UIViewController {

    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var passWordTF: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!{
        didSet{
            loginBtn.backgroundColor = UIColor.lightGray
            loginBtn.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let userSignal = userNameTF.reactive.continuousTextValues.map { (str) -> Bool in
            return str?.characters.count == 6
            }
        
        let passSignal = passWordTF.reactive.continuousTextValues.map { (str) -> Bool in
            return str?.characters.count == 6
            }
        
        userSignal.combineLatest(with: passSignal).map{ $0 && $1 }.map { (value) -> UIColor in
            self.loginBtn.isEnabled = value
            return value ? UIColor.green : UIColor.lightGray
            }.observe(on: QueueScheduler(qos: DispatchQoS.default, name: "com.dist", targeting: DispatchQueue.global())).observeValues { (color) in
                print("耗时操作 --- 可能是个网络请求")
                QueueScheduler.main.schedule {
                    self.loginBtn.backgroundColor = color
                }
        }
        
        loginBtn.reactive.controlEvents(UIControlEvents.touchUpInside).observe { (signal) in
            print("点到我了")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

