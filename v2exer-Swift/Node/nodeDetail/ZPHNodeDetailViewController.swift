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

class ZPHNodeDetailViewController: UIViewController {
    
    var name:String?
    var uri:String?
    var tableview:UITableView = {
        var tableview = UITableView()
        tableview.separatorStyle = .none
        return tableview
    }()
    
    var nmArray = [ZPHHome]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        tableview.dataSource = self
        tableview.delegate = self
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(kTopBarHeight)
            make.left.right.bottom.equalTo(self.view)
        }
    
        tableview.rowHeight = 102
        
        tableview.register(ZPHHomeTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        getRequest()
    }
    
    private func getRequest() {
        
        Alamofire.request(V2EXURL + (uri ?? ""), method: .get).responseString { (response) in
            
            if let reString = response.result.value {
                
//                print("restring = \(reString)")
                
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
                            
                            print("urlDoc = \(urlDoc)")
                            dic["url"] = V2EXURL + urlDoc
                        }
                        
                        print("dic = \(dic)")
                        let model = ZPHHome(dic: dic)
                        self.nmArray.append(model)
                    }
                    
                    self.tableview.reloadData()
                }
            }
        }
    }
    
    deinit {
        
        print("ZPHNodeDetailViewController deinit")
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

extension ZPHNodeDetailViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nmArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.nmArray[indexPath.row]
        
        let cell = ZPHHomeTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.homeModel = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        
        let model = self.nmArray[indexPath.row]
        
        let detail = ZPHHomeDetailViewController()
        detail.detailURL = model.url
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
