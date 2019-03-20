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
import MJRefresh
import DGElasticPullToRefresh
import NVActivityIndicatorView

class ZPHNodeDetailViewController: UIViewController {
    
    var name:String?
    var uri:String? {
        didSet {
            
            //不是以http开头的
            if !uri!.hasPrefix("http") {
                uri = V2EXURL + (uri ?? "")
            }
        }
    }
    var tableview:UITableView = {
        var tableview = UITableView()
        tableview.separatorStyle = .none
        tableview.rowHeight = 140
        return tableview
    }()
    var pageInt:Int = 1//页面
    var footer = MJRefreshAutoNormalFooter()
    
    var nmArray = [ZPHHome]()
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    
    var activityIndicatorView:NVActivityIndicatorView = {
        let activity = NVActivityIndicatorView(frame: CGRect.zero, type: NVActivityIndicatorType.ballRotateChase, color: tabColorGreen, padding: 2.0)
        return activity
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = name
        
        tableview.dataSource = self
        tableview.delegate = self
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(kTopBarHeight)
            make.left.right.bottom.equalTo(self.view)
        }
        
        tableview.register(ZPHHomeTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        tableview.mj_footer = footer
        
        loadingView.tintColor = UIColor(red: 78.0/255.0, green: 221.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        tableview.dg_addPullToRefreshWithActionHandler({
            [weak self]() -> Void in
            
            self?.pageInt = 1
            self?.nmArray.removeAll()
            self?.getRequest()
        }, loadingView: loadingView)
        tableview.dg_setPullToRefreshFillColor(UIColor(red: 27.0/255.0, green: 146.0/255.0, blue: 52.0/255.0, alpha: 1.0))
        tableview.dg_setPullToRefreshBackgroundColor(tableview.backgroundColor!)
        
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self.view)
            make.size.equalTo(CGSize(width: 80, height: 40))
        }
        activityIndicatorView.startAnimating()

        getRequest()
    }
    
    @objc private func footerRefresh() {
        
        pageInt += 1
        getRequest()
    }
    
    private func getRequest() {
        
        Alamofire.request(uri! + "?p=\(pageInt)", method: .get).responseString { (response) in
            
            if let reString = response.result.value {
                
//                print("restring = \(reString)")
                self.tableview.dg_stopLoading()//停止下拉
                
                if self.footer.isRefreshing {
                    self.footer.endRefreshing()
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
                            
                            print("urlDoc = \(urlDoc)")
                            dic["url"] = V2EXURL + urlDoc
                        }
                        
                        print("dic = \(dic)")
                        let model = ZPHHome(dic: dic)
                        self.nmArray.append(model)
                    }
                    
                    self.tableview.reloadData()
                    if self.activityIndicatorView.isAnimating {
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }
    }
    
    deinit {
        
        print("ZPHNodeDetailViewController deinit")
        tableview.dg_removePullToRefresh()
    }
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
        
//        let detail = ZPHHomeDetailViewController()
//        detail.detailURL = model.url
//        self.navigationController?.pushViewController(detail, animated: true)
        
        let detail = ZPHContentDetailViewController()
        detail.detailURL = model.url
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
