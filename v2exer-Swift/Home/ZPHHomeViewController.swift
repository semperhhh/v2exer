//
//  ZPHHomeViewController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2018/12/20.
//  Copyright © 2018 zph. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import MJRefresh
import DGElasticPullToRefresh
import NVActivityIndicatorView

class ZPHHomeViewController: UIViewController {
    
    var tableView = UITableView()
    var nmArray:[ZPHHome] = [ZPHHome]()
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    var activityIndicatorView:NVActivityIndicatorView = {
        let activity = NVActivityIndicatorView(frame: CGRect.zero, type: NVActivityIndicatorType.lineScale, color: tabColorGreen, padding: 2.0)
        return activity
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "最新"
        
        tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 102
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
    
    //MARK:刷新
    @objc private func headerRefresh() {
        print("headerRefresh")
//        getRequest()
    }
    
    func refresh() {
        print("refresh")
    }
    
    //MARK:网络请求
    func getRequest() {
        
        Alamofire.request("https://www.v2ex.com/api/topics/latest.json", method: .get).responseJSON { (response) in

            if let data = response.result.value {

                if let dataArray = data as? [[String:Any]] {

                    for (index,dict) in dataArray.enumerated() {

                        let model = ZPHHome(dic: dict)

//                        print("index = \(index)")
                        self.nmArray.append(model)
                    }
                    self.tableView.dg_stopLoading()
                    self.tableView.reloadData()
                    if self.activityIndicatorView.isAnimating {
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }
    }
    
    deinit {
        
        tableView.dg_removePullToRefresh()
    }
}

//MARK: - TableViewDataSource
extension ZPHHomeViewController:UITableViewDataSource,UITableViewDelegate {
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
