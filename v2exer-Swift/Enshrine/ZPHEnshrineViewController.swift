//
//  ZPHEnshrineViewController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/2/13.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHEnshrineViewController: ZPHBaseRefreshPlainController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.randomColor
        self.navigationItem.title = "收藏"

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kTopBarHeight)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        tableView.register(ZPHHomeTableViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        
        self.tableView.mj_header.beginRefreshing()
    }
    
    override func refreshMore() {
        
        self.tableView.mj_footer.endRefreshing()
    }
    
    override func refreshLoad() {
        
        let url = V2EXURL + "/my/topics"
        
        Alamofire.request(url, method: .get).responseString { (response) in
            
            self.tableView.mj_header.endRefreshing()
            self.dataArray.removeAll()
            
            if let reString = response.result.value {
                
                let jiDoc = Ji(htmlString: reString)
                
                if let messageDic = jiDoc?.xPath("//div[@class='box']/div[@class='message']")?.first {
                    
                    print(messageDic.content ?? "messagedic is nil")
                    
                    //无数据展示
                    return
                }
                
                if let cellsDoc = jiDoc?.xPath("//div[@class='cell item']/table/tr") {
                    
                    for cell in cellsDoc {
                        
//                        print(cell)
                        var dic = [String:String]()
                        
                        if let cellTitle = cell.xPath("./td/span/a").first {
                            
//                            print("cellTitle = \(cellTitle)")
                            dic["title"] = cellTitle.content
                        }
                        
                        if let cellLastReply = cell.xPath("./td/span/strong/a").first {
                            
//                            print("lastReply = \(cellLastReply)")
                            dic["last_reply_by"] = cellLastReply.content
                        }
                        
                        if let cellNode = cell.xPath("./td/span/a[@class='node']").first {
                            
//                            print("cellNode = \(cellNode)")
                            dic["nodeTitle"] = cellNode.content
                        }
                        
                        if let cellavatar = cell.xPath("./td/a/img").first?["src"] {
                            
//                            print("cellavatar = \(cellavatar)")
                            dic["avatar"] = cellavatar
                        }
                        
                        if let cellNodeUrl = cell.xPath("./td/span/a[@class='node']").first?["href"] {
                            
//                            print("cellNodeUrl = \(cellNodeUrl)")
                            dic["nodeUrl"] = cellNodeUrl
                        }
                        
                        if let cellUrl = cell.xPath("./td/span/a").first?["href"] {
                            
                            print("cellUrl = \(cellUrl)")
                            dic["url"] = V2EXURL + cellUrl
                        }
                        
                        print("dic = \(dic)")
                        let model = ZPHHome.init(dic: dic)
                        self.dataArray.append(model)
                    }
                    
                    self.tableView.reloadData()
                }
            }
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
    
    deinit {
        
        self.tableView.dg_removePullToRefresh()
    }

}

//MARK: - TableViewDataSource
extension ZPHEnshrineViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ZPHHomeTableViewCell
        
        cell.homeModel = self.dataArray[indexPath.row] as? ZPHHome
        
        cell.headImageBlock = { userHref in
            
            print("点击了头像 \(userHref)")
            let userDetail = ZPHUserDetailViewController()
            userDetail.userHref = userHref
            //用户地址 循环引用
            userDetail.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(userDetail, animated: true)
        }
        
        cell.nodeTitleBlock = { url,name in
            
            print("点击了节点 \(url)")
            let nodeDetail = ZPHNodeDetailViewController()
            nodeDetail.uri = url
            nodeDetail.name = name
            nodeDetail.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(nodeDetail, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model:ZPHHome = self.dataArray[indexPath.row] as! ZPHHome
        
        //        let detail = ZPHHomeDetailViewController()
        //        detail.hidesBottomBarWhenPushed = true
        //        detail.detailURL = model.url
        //        self.navigationController?.pushViewController(detail, animated: true)
        
        let detail = ZPHContentDetailViewController()
        detail.detailURL = model.url
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model:ZPHHome = self.dataArray[indexPath.row] as! ZPHHome
        
        return model.cellHeight
    }
}
