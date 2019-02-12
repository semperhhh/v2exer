//
//  ZPHHotViewController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/1/31.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit
import Alamofire
import DGElasticPullToRefresh
import NVActivityIndicatorView

class ZPHHotViewController: UIViewController {
    
    private var tableview:UITableView = {
        var tableview = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableview.separatorStyle = .none
        tableview.rowHeight = 102
        return tableview
    }()
    
    private var nmArray = [ZPHHome]()
    
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    
    var activityIndicatorView:NVActivityIndicatorView = {
        let activity = NVActivityIndicatorView(frame: CGRect.zero, type: NVActivityIndicatorType.lineScale, color: tabColorGreen, padding: 2.0)
        return activity
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "最热"
        
        tableview.dataSource = self
        tableview.delegate = self
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(kTopBarHeight)
            make.left.right.bottom.equalTo(self.view)
        }
        tableview.register(ZPHHomeTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        loadingView.tintColor = UIColor(red: 78.0/255.0, green: 221.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        tableview.dg_addPullToRefreshWithActionHandler({
            [weak self]() -> Void in
            
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
    
    private func getRequest() {
        
        let url = "\(V2EXURL)/api/topics/hot.json"
        Alamofire.request(url, method: .get).responseJSON { (response) in
            
            if let data = response.result.value {
                
                if let dataArray = data as? [[String:Any]] {
                    
                    for (index,dict) in dataArray.enumerated() {
                        
                        let model = ZPHHome(dic: dict)
                        
                        //                        print("index = \(index)")
                        self.nmArray.append(model)
                    }
                    self.tableview.dg_stopLoading()
                    self.tableview.reloadData()
                    if self.activityIndicatorView.isAnimating {
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }
    }
    
    deinit {
        tableview.dg_removePullToRefresh()
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

extension ZPHHotViewController:UITableViewDataSource,UITableViewDelegate {
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = self.nmArray[indexPath.row]
        
//        let detail = ZPHHomeDetailViewController()
//        detail.detailURL = model.url
//        detail.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(detail, animated: true)
        
        let detail = ZPHContentDetailViewController()
        detail.detailURL = model.url
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
