//
//  ZPHUserDetailReplyController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/3/23.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit
import JXSegmentedView

class ZPHUserDetailReplyController: UIViewController {
    
    /// 回复数组
    public var replyArray = [ZPHUserDetail]() {
        didSet {
            
            self.replyTableView.reloadData()
        }
    }
    
    var naviController:UINavigationController?
    
    //回复列表
    private var replyTableView:UITableView = {
        let tableview = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableview.backgroundColor = UIColor.white
        tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableview.showsVerticalScrollIndicator = false
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        replyTableView.dataSource = self
        replyTableView.delegate = self
        self.view.addSubview(replyTableView)
        replyTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
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

extension ZPHUserDetailReplyController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.replyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.replyArray[indexPath.row]
        let cell = ZPHUserDetailCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ZPHUserDetailCell")
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = self.replyArray[indexPath.row]
        
        return model.cellHeight
    }
}

extension ZPHUserDetailReplyController:JXSegmentedListContainerViewListDelegate {
    
    func listView() -> UIView {
        
        return self.view
    }
}
