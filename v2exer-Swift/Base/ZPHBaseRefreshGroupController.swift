//
//  ZPHRefreshGroupController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/5/26.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit
import MJRefresh

class ZPHBaseRefreshGroupController: ZPHBaseTableGroupController {
    
    /// 顶部刷新
    let header = MJRefreshNormalHeader()
    
    /// 底部刷新
    let footer = MJRefreshAutoNormalFooter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        header.setRefreshingTarget(self, refreshingAction: #selector(refreshLoad))
        header.setTitle("需要更多充电", for: MJRefreshState.idle)
        header.setTitle("正在火速加载", for: MJRefreshState.refreshing)
        header.setTitle("松开就可以充电", for: MJRefreshState.pulling)
        header.lastUpdatedTimeLabel.isHidden = true
        self.tableView.mj_header = header
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(refreshMore))
        footer.setTitle("暂无更多资源", for: MJRefreshState.noMoreData)
        self.tableView.mj_footer = footer
    }
    
    @objc func refreshLoad () {
        
        print("下拉刷新")
    }
    
    @objc func refreshMore () {
        
        print("上拉刷新")
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
