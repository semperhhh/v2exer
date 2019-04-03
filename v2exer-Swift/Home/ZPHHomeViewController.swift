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
    
    //列表
    private var tableview:UITableView = {
        let tableview = UITableView(frame: CGRect.zero, style: .grouped)
        tableview.rowHeight = 130
        tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableview
    }()
    
    //日期
    private var weekCollectionView:UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: kScreenWidth / 7, height: 50)
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    //分页滚动
    private var collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: kScreenWidth, height: 120)
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.backgroundColor = UIColor.clear
        return collection
    }()
    
    //日期数组
    private var dataArray:[String] = ["1", "2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "首页"
        
        //列表
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(ZPHHomeTableViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    
        //加载
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
        
        let group = DispatchGroup.init()
        
        group.enter()
        
        Alamofire.request("https://www.v2ex.com/api/topics/latest.json", method: .get).responseJSON { (response) in

            if let data = response.result.value {

                if let dataArray = data as? [[String:Any]] {

                    for dict in dataArray {

                        let model = ZPHHome(dic: dict)
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
                    
                    for dict in dataArray {
                        
                        let model = ZPHHome(dic: dict)
                        self.rightArray.append(model)
                    }
                    
                    group.leave()
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            self.tableview.reloadData()
            self.tableview.dg_stopLoading()
            self.collectionView.reloadData()
            if self.activityIndicatorView.isAnimating {
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    deinit {
        

    }
}

//MARK: - 日期

//MARK: - TableViewDataSource
extension ZPHHomeViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nmArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = nmArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ZPHHomeTableViewCell
        cell.selectionStyle = .none
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
        
        let model = nmArray[indexPath.row]

        let detail = ZPHContentDetailViewController()
        detail.detailURL = model.url
        detail.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 230
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        let weekView = ZPHHomeWeekView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 30))
        view.addSubview(weekView)
        
        //星期
        self.weekCollectionView.frame = CGRect(x: 0, y: 30, width: kScreenWidth, height: 50)
        self.weekCollectionView.dataSource = self
        self.weekCollectionView.delegate = self
        self.weekCollectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cellWeek")
        view.addSubview(self.weekCollectionView)
        
        let label = UILabel(frame: CGRect(x: 4, y: 80, width: kScreenWidth, height: 30))
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "当前最热"
        view.addSubview(label)
        
        //轮播图
        self.collectionView.frame = CGRect(x: 0, y: 110, width: kScreenWidth, height: 120)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(ZPHHomeCollectionCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        view.addSubview(self.collectionView)

        return view
    }
}

//MARK:--UICollectionViewDelegate
extension ZPHHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView === self.weekCollectionView {
            return self.dataArray.count
        }
        return self.rightArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView === self.weekCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellWeek", for: indexPath)
            let lab = UILabel()
            lab.text = self.dataArray[indexPath.row]
            lab.textAlignment = NSTextAlignment.center
            cell.contentView.addSubview(lab)
            lab.snp.makeConstraints { (make) in
                make.edges.equalTo(cell.contentView)
            }
            return cell
        }
        
        let model = self.rightArray[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ZPHHomeCollectionCell
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if collectionView == self.weekCollectionView {
            
            return
        }
        
        let model = self.rightArray[indexPath.row]
        
        let detail = ZPHContentDetailViewController()
        detail.detailURL = model.url
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
