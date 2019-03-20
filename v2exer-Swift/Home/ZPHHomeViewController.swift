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
    
    var nmArray:[ZPHHome] = [ZPHHome]()//左边数据
    var rightArray:[ZPHHome] = [ZPHHome]()//右边数据
    
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    var activityIndicatorView:NVActivityIndicatorView = {
        let activity = NVActivityIndicatorView(frame: CGRect.zero, type: NVActivityIndicatorType.lineScale, color: tabColorGreen, padding: 2.0)
        return activity
    }()
    
    var scrollView:UIScrollView = {
        let scrollview = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - CGFloat(kTopBarHeight) - CGFloat(kTabBarHeight)))
        scrollview.contentSize = CGSize(width: kScreenWidth * 2, height: kScreenHeight - CGFloat(kTopBarHeight) - CGFloat(kTabBarHeight))
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.isPagingEnabled = true
        return scrollview
    }()
    
    //左边的列表
    var leftTableView:UITableView = {
        let tableview = UITableView(frame: CGRect.zero, style: .plain)
        tableview.rowHeight = 130
        tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableview
    }()
    
    //右边的列表
    var rightTableView:UITableView = {
        let tableview = UITableView(frame: CGRect.zero, style: .plain)
        tableview.rowHeight = 130
        tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableview
    }()
    
    let segment:UISegmentedControl = {
        let segment = UISegmentedControl.init(items: ["最新","最热"])
        segment.frame = CGRect.init(x: 0, y: 0, width: 150.0, height: 30.0)
        segment.selectedSegmentIndex = 0
        segment.tintColor = UIColor.white
        return segment
    }()
    
    @objc func segmentAction() {
        
        let select = segment.selectedSegmentIndex
        
        switch select {
        case 0:
            print("segmentAction -- 0")
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            break
        case 1:
            print("segmentAction -- 1")
            scrollView.setContentOffset(CGPoint(x: kScreenWidth, y: 0), animated: true)
            break
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "最新"
        
        self.navigationItem.titleView = segment
        segment.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        
        self.view.addSubview(scrollView)
        scrollView.delegate = self
        
        scrollView.addSubview(leftTableView)
        leftTableView.dataSource = self
        leftTableView.delegate = self
        leftTableView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(scrollView.snp.left)
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(scrollView)
        }
        leftTableView.register(ZPHHomeTableViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        
        scrollView.addSubview(rightTableView)
        rightTableView.dataSource = self
        rightTableView.delegate = self
        rightTableView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(kScreenWidth)
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(scrollView)
        }
        rightTableView.register(ZPHHomeTableViewCell.classForCoder(), forCellReuseIdentifier: "cellId")

        loadingView.tintColor = UIColor(red: 78.0/255.0, green: 221.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        leftTableView.dg_addPullToRefreshWithActionHandler({
            [weak self]() -> Void in
            
            self?.nmArray.removeAll()
            self?.getRequest()

        }, loadingView: loadingView)
        leftTableView.dg_setPullToRefreshFillColor(UIColor(red: 27.0/255.0, green: 146.0/255.0, blue: 52.0/255.0, alpha: 1.0))
        leftTableView.dg_setPullToRefreshBackgroundColor(leftTableView.backgroundColor!)
  
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self.view)
            make.size.equalTo(CGSize(width: 80, height: 40))
        }
        
        activityIndicatorView.startAnimating()
        
        getRequest()
    }
    
    //滚动停止
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x == 0 {//最新
            segment.selectedSegmentIndex = 0
        }else { //最热
            segment.selectedSegmentIndex = 1
        }
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
        
        var group = DispatchGroup.init()
        
        group.enter()
        
        Alamofire.request("https://www.v2ex.com/api/topics/latest.json", method: .get).responseJSON { (response) in

            if let data = response.result.value {

                if let dataArray = data as? [[String:Any]] {

                    for (index,dict) in dataArray.enumerated() {

                        let model = ZPHHome(dic: dict)

//                        print("index = \(index)")
                        self.nmArray.append(model)
                    }
                    
                    group.leave()
                }
            }
        }
        
        group.enter()
        
        let url = "\(V2EXURL)/api/topics/hot.json"
        Alamofire.request(url, method: .get).responseJSON { (response) in
            
            if let data = response.result.value {
                
                if let dataArray = data as? [[String:Any]] {
                    
                    for (index,dict) in dataArray.enumerated() {
                        
                        let model = ZPHHome(dic: dict)
                        
                        //                        print("index = \(index)")
                        self.rightArray.append(model)
                    }
                    
                    group.leave()
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            self.leftTableView.reloadData()
            self.leftTableView.dg_stopLoading()
            self.rightTableView.reloadData()
            self.rightTableView.dg_stopLoading()
            if self.activityIndicatorView.isAnimating {
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    deinit {
        
        leftTableView.dg_removePullToRefresh()
    }
}

//MARK: - TableViewDataSource
extension ZPHHomeViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.leftTableView {
            return nmArray.count
        }else
            if tableView == self.rightTableView {
            return rightArray.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var model:ZPHHome?
        
        if tableView == leftTableView {
            model = nmArray[indexPath.row]
        }else if tableView == rightTableView {
            model = rightArray[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ZPHHomeTableViewCell
        
        cell.homeModel = model
        
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
        
        var model:ZPHHome?
        if tableView == leftTableView {
            model = nmArray[indexPath.row]
        }else if tableView == rightTableView {
            model = rightArray[indexPath.row]
        }
        
        let detail = ZPHContentDetailViewController()
        detail.detailURL = model?.url
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
    }
}


