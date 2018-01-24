//
//  ViewController.swift
//  ExtensionProjects
//
//  Created by 李子鹏 on 2018/1/19.
//  Copyright © 2018年 zdp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.loadRequest(URLRequest.init(url: URL.init(string: "http://www.lnlt10010.com/kmall/subway/index.do?shopid=1")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

