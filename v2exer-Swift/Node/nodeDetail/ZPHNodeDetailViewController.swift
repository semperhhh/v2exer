//
//  ZPHNodeDetailViewController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/1/30.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit
import Alamofire
import Ji

class ZPHNodeDetailViewController: ZPHBaseRefreshPlainController {
    
    var name:String?
    var uri:String? {
        didSet {
            
            //不是以http开头的
            if !uri!.hasPrefix("http") {
                uri = V2EXURL + (uri ?? "")
            }
        }
    }

    var pageInt:Int = 1//页面

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = name
        
        self.tableView.rowHeight = 140
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kTopBarHeight)
            make.left.right.bottom.equalTo(self.view)
        }
        self.tableView.register(ZPHHomeTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        self.tableView.mj_header.beginRefreshing()
    }
    
    override func refreshMore() {
        
        pageInt += 1
        refreshLoad()
    }
    
    override func refreshLoad() {

        Alamofire.request(uri! + "?p=\(pageInt)", method: .get).responseString { (response) in
            
            if let reString = response.result.value {
                
//                print("restring = \(reString)")
                if self.tableView.mj_header.isRefreshing {
                    self.tableView.mj_header.endRefreshing()
                    self.dataArray.removeAll()
                }
                
                if self.tableView.mj_footer.isRefreshing {
                    self.tableView.mj_footer.endRefreshing()
                }
                
                let jiDoc = Ji(htmlString: reString)
                if let cells:[JiNode] = jiDoc?.xPath("//div[@id='TopicsNode']/div/table/tr")
                {
                    
//                    print("cells = \(cells)")
                    
                    for cell in cells {
                        
                        var dic = [String:String]()
                        
                        if let imgDoc = cell.xPath("./td/a/img").first?["src"] {

//                            print("img = \(imgDoc)")
                            dic["avatar"] = imgDoc
                        }
                        
                        if let titleDoc = cell.xPath("./td/span/a").first {
                            
//                            print("title = \(titleDoc)")
                            dic["title"] = titleDoc.content
                        }
                        
                        if let lastReply = cell.xPath("./td/span/strong/a").last {
                            
//                            print("lastReply = \(lastReply)")
                            dic["last_reply_by"] = lastReply.content
                        }
                        
                        if let urlDoc = cell.xPath("./td/span/a").first?["href"] {
                            
//                            print("urlDoc = \(urlDoc)")
                            dic["url"] = V2EXURL + urlDoc
                        }
                        
                        if let userHref = cell.xPath("./td/span/strong/a").first?["href"] {
                            
                            dic["userHref"] = V2EXURL + userHref
                        }
                        
                        print("dic = \(dic)")
                        let model = ZPHHome(dic: dic)
                        self.dataArray.append(model)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ZPHNodeDetailViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.dataArray[indexPath.row] as! ZPHHome
        
        let cell = ZPHHomeTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.homeModel = model
        
        cell.headImageBlock = { userHref in
            
            print("点击了头像 \(userHref)")
            let userDetail = ZPHUserDetailViewController()
            userDetail.userHref = userHref
            //用户地址 循环引用
            userDetail.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(userDetail, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = self.dataArray[indexPath.row] as! ZPHHome
        
//        let detail = ZPHHomeDetailViewController()
//        detail.detailURL = model.url
//        self.navigationController?.pushViewController(detail, animated: true)
        
        let detail = ZPHContentDetailViewController()
        detail.detailURL = model.url
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
