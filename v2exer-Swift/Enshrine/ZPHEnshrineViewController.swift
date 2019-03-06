//
//  ZPHEnshrineViewController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/2/13.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHEnshrineViewController: UIViewController {
    
    var tableView:UITableView = {
        var tableview = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        return tableview
    }()
    
    //数组
    var nmArray = [ZPHHome]()
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    var activityIndicatorView:NVActivityIndicatorView = {
        let activity = NVActivityIndicatorView(frame: CGRect.zero, type: NVActivityIndicatorType.lineScale, color: tabColorGreen, padding: 2.0)
        return activity
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = RANDOMColor
        self.navigationItem.title = "收藏"
        
        tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 130
        tableView.separatorStyle = .none//分割线
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kTopBarHeight)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        tableView.register(ZPHHomeTableViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        
        loadingView.tintColor = UIColor(red: 78.0/255.0, green: 221.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({
            [weak self]() -> Void in
            
            self?.nmArray.removeAll()
            self?.getRequest()
            
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 27.0/255.0, green: 146.0/255.0, blue: 52.0/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self.view)
            make.size.equalTo(CGSize(width: 80, height: 40))
        }
        
        activityIndicatorView.startAnimating()
        
        getRequest()
    }
    
    private func getRequest() {
        
        let url = V2EXURL + "/my/topics"
        
        Alamofire.request(url, method: .get).responseString { (response) in
            
            if let reString = response.result.value {
                
                self.tableView.dg_stopLoading()//停止下拉
                self.activityIndicatorView.stopAnimating()
                
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
                        self.nmArray.append(model)
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
extension ZPHEnshrineViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nmArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ZPHHomeTableViewCell
        
        cell.homeModel = nmArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = nmArray[indexPath.row]
        
        //        let detail = ZPHHomeDetailViewController()
        //        detail.hidesBottomBarWhenPushed = true
        //        detail.detailURL = model.url
        //        self.navigationController?.pushViewController(detail, animated: true)
        
        let detail = ZPHContentDetailViewController()
        detail.detailURL = model.url
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
