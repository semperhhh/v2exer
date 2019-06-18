//
//  ZPHCautionViewController.swift
//  v2exer-Swift
//
//  Created by zph on 2019/6/18.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHCautionViewController: ZPHBaseRefreshPlainController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "消息"
        self.tableView.mj_footer.isHidden = true
        self.tableView.showEmpty(image: nil, title: nil)
    }
    
    override func refreshLoad() {
        
        self.tableView.mj_header.endRefreshing()
    }
}
