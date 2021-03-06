//
//  ZPHBaseTableGroupController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/5/26.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHBaseTableGroupController: ZPHBaseViewController {
    
    /// 列表
    var tableView = UITableView()
    
    /// 数据
    var dataArray = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), style: .grouped)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.view.addSubview(self.tableView)
    }

}

extension ZPHBaseTableGroupController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
