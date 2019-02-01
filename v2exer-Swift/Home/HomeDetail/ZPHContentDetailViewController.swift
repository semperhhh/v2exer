//
//  ZPHContentDetailViewController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/1/31.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit
import Alamofire

class ZPHContentDetailViewController: UIViewController {
    
    var detailURL:String?
    var contentLabel:UILabel = {
        var lab = UILabel()
        return lab
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "内容"
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(kTopBarHeight)
            make.left.right.equalTo(self.view)
        }
        
        getRequest()
    }
    
    private func getRequest() {
        
        Alamofire.request(detailURL!).responseString { (response) in
            
            if let reString = response.result.value {
                
                print("reString = \(reString)")
                
                var htmlText = "<h1>我感觉我连不到境外服务器了 用 SSH</h1>"
                do {
                    let attrStr = try NSAttributedString(data: htmlText.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                    
                    self.contentLabel.attributedText = attrStr
                } catch  {
                    print("error")
                }
            }
        }
    }
    
    deinit {
        print("ZPHContentDetailViewController -- deinit")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
