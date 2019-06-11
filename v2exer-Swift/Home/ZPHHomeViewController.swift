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

class ZPHHomeViewController: ZPHBaseRefreshPlainController {
    
    var rightArray:[ZPHHome] = [ZPHHome]()//右边数据
    
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
    private var dateArray:[String] = []
    
    //当前日期位置
    private var selectDateIndex:NSInteger = 0
    
    //当前日期星期几
    private var selectDateWeek:Int = 0
    
    //小白点
    private var pageControl:UIPageControl = UIPageControl()
    
    //计时器
    private var timer:Timer?
    
    //当前轮播
    private var currentCollect = 0
    
    private var headView: ZPHHomeHeadView = {
       
        let view = ZPHHomeHeadView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 150))
        return view
    }()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.tableView.register(ZPHHomeTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        self.tableView.tableHeaderView = headView
    
        self.refreshLoad()
    }
    
    override func refreshMore() {
        
        self.tableView.mj_footer.endRefreshingWithNoMoreData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    //MARK:网络请求
    override func refreshLoad() {
        
        let group = DispatchGroup.init()
        
        group.enter()
        
        Alamofire.request("https://www.v2ex.com/api/topics/latest.json", method: .get).responseJSON { (response) in

            if let data = response.result.value {

                if let dataArray = data as? [[String:Any]] {
                    
                    self.dataArray.removeAll()

                    for dict in dataArray {

                        let model = ZPHHome(dic: dict)
                        self.dataArray.append(model)
                    }
                }
            }
            group.leave()
        }
        
        group.enter()
        
        let url = "\(V2EXURL)/api/topics/hot.json"
        Alamofire.request(url, method: .get).responseJSON { (response) in
            
            if let data = response.result.value {
                
                if let dataArray = data as? [[String:Any]] {
                    
                    if let dict = dataArray.first {
                        self.headView.model = ZPHHome(dic: dict)
                    }
                }
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
//            self.collectionView.reloadData()
        }
    }
}

extension Date {
    
    //MARK:根据date获取当月第一天周几
    public func calendarToFirstWeekDay() -> (NSInteger) {
        
        var calendar = Calendar.current//日历
        calendar.firstWeekday = 1//日历的第一个工作日是星期一
        var dateComponents = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: self)//日历的部件
        dateComponents.day = 1//日历的第一天
        let firstDayOfMonthDate = calendar.date(from: dateComponents)
        let firstDay = calendar.ordinality(of: Calendar.Component.weekday, in: Calendar.Component.weekOfMonth, for: firstDayOfMonthDate!)
        return firstDay! - 1 //美国时间周日为星期的第一天，所以周日-周六为1-7，改为0-6方便计算
    }
    
    //MARK:获取当月有多少天
    public func calendarToMonthDays() -> NSInteger {
        
        let calend = Calendar.current
        let daysInOfMonth = calend.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self)
        return daysInOfMonth!.count
    }
    
    //MARK:获取偏移个月的date
    public func calendarGetDateOffsetMonths(_ offset: NSInteger) -> Date {
        
        let calend = Calendar.current
        var lastmonthComps = DateComponents()
        lastmonthComps.setValue(offset, for: Calendar.Component.month)
        let newDate = calend.date(byAdding: lastmonthComps, to: self)
        return newDate!
    }
}


//MARK: - TableViewDataSource
extension ZPHHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model:ZPHHome = dataArray[indexPath.row] as! ZPHHome
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ZPHHomeTableViewCell
        cell.selectionStyle = .none
        cell.homeModel = model
        
        cell.headImageBlock = { userHref in
            
            print("点击了头像 \(userHref)")
            let userDetail = ZPHUserDetailViewController()
            userDetail.userHref = userHref
            //用户地址 循环引用
            userDetail.hidesBottomBarWhenPushed = true
            self.navigationController?.navigationBar.prefersLargeTitles = false
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model:ZPHHome = dataArray[indexPath.row] as! ZPHHome
        
        return model.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model:ZPHHome = self.dataArray[indexPath.row] as! ZPHHome

        let detail = ZPHContentDetailViewController()
        detail.detailURL = model.url
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        //星期
        self.weekCollectionView.frame = CGRect(x: 0, y: 30, width: kScreenWidth, height: 50)
        self.weekCollectionView.dataSource = self
        self.weekCollectionView.delegate = self
        self.weekCollectionView.register(ZPHHomeTimeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cellWeek")
//        view.addSubview(self.weekCollectionView)
        
        let label = UILabel(frame: CGRect(x: 4, y: 0, width: kScreenWidth, height: 30))
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "当前最热"
//        view.addSubview(label)
        
        //轮播图
        self.collectionView.frame = CGRect(x: 0, y: 30, width: kScreenWidth, height: 120)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(ZPHHomeCollectionCell.classForCoder(), forCellWithReuseIdentifier: "cell")
//        view.addSubview(self.collectionView)
        
        //小白点
        self.pageControl.frame = CGRect(x: 0, y: 150, width: 0, height: 20)
        self.pageControl.numberOfPages = self.rightArray.count
        self.pageControl.currentPage = 0
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.addTarget(self, action: #selector(pageControlChange), for: .valueChanged)
//        view.addSubview(self.pageControl)

        return view
    }
    */
    
    @objc func pageControlChange() {
        
        print(self.pageControl.currentPage);
        self.currentCollect = self.pageControl.currentPage;
        self.collectionView .scrollToItem(at: IndexPath(item: self.pageControl.currentPage, section: 0), at: .left, animated: true)
    }
}

//MARK:--UICollectionViewDelegate
extension ZPHHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView === self.weekCollectionView {
            return self.dateArray.count
        }
        return self.rightArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView === self.weekCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellWeek", for: indexPath) as! ZPHHomeTimeCollectionViewCell
            cell.timeLabel.text = self.dateArray[indexPath.row]
            if indexPath.item > self.selectDateIndex {
                cell.timeLabel.textColor = UIColor.black
            }else {
                cell.timeLabel.textColor = UIColor.gray
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
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
