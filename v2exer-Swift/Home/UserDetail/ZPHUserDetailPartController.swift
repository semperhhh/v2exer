//
//  ZPHUserDetailPartController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/3/23.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit
import JXSegmentedView

class ZPHUserDetailPartController: UIViewController {
    
    public var partArray = [ZPHUserDetailPart]()
    
    var naviController:UINavigationController?
    
    //回复列表
    private var partTableView:UITableView = {
        let tableview = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableview.backgroundColor = UIColor.white
        tableview.showsVerticalScrollIndicator = false
        tableview.tableFooterView = UIView()
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.view.backgroundColor = UIColor.white
        partTableView.dataSource = self
        partTableView.delegate = self
        self.view.addSubview(partTableView)
        partTableView.snp.makeConstraints { (make) in
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

extension ZPHUserDetailPartController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.partArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.partArray[indexPath.row]
        
        let cell = ZPHUserDetailPartCell(style: .default, reuseIdentifier: "cell")
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = self.partArray[indexPath.row]
        
        let contentDetail = ZPHContentDetailViewController()
        contentDetail.detailURL = model.contentHref
        naviController?.pushViewController(contentDetail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = self.partArray[indexPath.row]
        return model.cellHeight
    }
}

extension ZPHUserDetailPartController:JXSegmentedListContainerViewListDelegate {
    
    func listView() -> UIView {
    
        return self.view
    }
}


