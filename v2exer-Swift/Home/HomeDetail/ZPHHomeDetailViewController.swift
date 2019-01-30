//
//  ZPHHomeDetailViewController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/1/10.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit
import Alamofire
import Ji
import WebKit

class ZPHHomeDetailViewController: UIViewController {
    
    var detailURL:String?
    var webView:WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white

        let URLReq = URLRequest(url: URL(string:detailURL ?? "")!)
        webView.load(URLReq)
        self.view.addSubview(webView)
        
//        getRequest()
    }
    
    //MARK:网络请求
    func getRequest() {
        
        Alamofire.request("https://www.v2ex.com/t/525709", method: .get).responseData { (response) in
            
            if let data = response.result.value {
                
                let jiDoc = Ji(htmlData: data)!
                
                if let aRootNode = jiDoc.xPath("//div[@class='sep10']")?.first {
                    
                }
            }
        }
    }

}
