//
//  ZPHUserDetailViewController.swift
//  v2exer-Swift
//
//  Created by 张鹏辉 on 2019/3/7.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit
import JXSegmentedView

class ZPHUserDetailViewController: UIViewController {
    
    /// 用户地址
    var userHref:String?
    
    /// 回复数组
    var replyArray = [ZPHUserDetail]()
    
    //上面的介绍
    var topView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    //介绍字典
    var detailDic = [String:String]()
    
    //头像
    var headImageView:UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.white
        imgView.layer.cornerRadius = 32
        imgView.layer.masksToBounds = true
        return imgView
    }()

    //名字
    var userNameLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 120.0/255.0, green: 118.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
        return label
    }()
    
    //排名
    var dauLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 117.0/255.0, green: 218.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.textColor = UIColor.white
        return label
    }()
    
    //特别关注
    private var specialButton:UIButton = {
        
        let btn = UIButton()
        btn.setTitle("特别关注", for: .normal)
        btn.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.layer.cornerRadius = 6
        return btn
    }()
    
    //屏蔽
    private var shieldButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        btn.setTitle("屏蔽用户", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.layer.cornerRadius = 6
        return btn
    }()

    //分割列表
    var segmentedView:JXSegmentedView = JXSegmentedView()
    //分割列表数据
    var segmentedDataSource:JXSegmentedTitleDataSource = JXSegmentedTitleDataSource()
    //列表滚动视图
    var listContainerView:JXSegmentedListContainerView?
    
    //参与列表
    var userDetailReply = ZPHUserDetailReplyController()
    //发布列表
    var userDetailPart = ZPHUserDetailPartController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "个人介绍"
        
        self.requestNetwork()
    
    }
    
    func getTopViewUI() {
        
        self.view.addSubview(topView)
        topView.addSubview(headImageView)
        topView.addSubview(userNameLabel)
        topView.addSubview(dauLabel)
        topView.addSubview(self.specialButton)
        topView.addSubview(self.shieldButton)
        
        topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(kTopBarHeight)
            make.height.equalTo(200)
        }
    
        headImageView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.top).offset(30)
            make.left.equalTo(topView).offset(24)
            make.size.equalTo(CGSize(width: 64, height: 64))
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(headImageView)
            make.left.equalTo(headImageView.snp.right).offset(10)
        }
        
        dauLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.left.equalTo(userNameLabel)
            make.height.equalTo(24)
        }
        
        self.specialButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(topView.snp.bottom).offset(-18)
            make.left.equalTo(topView).offset(30)
            make.size.equalTo(CGSize(width: 150, height: 54))
        }
        
        self.shieldButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.specialButton)
            make.right.equalTo(topView.snp.right).offset(-30)
            make.size.equalTo(CGSize(width: 150, height: 54))
        }
        
        self.segmentedView.delegate = self
        self.segmentedView.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        self.view.addSubview(self.segmentedView)
        self.segmentedView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(56)
        }
        
        self.segmentedDataSource.titles = ["参与的主题", "发布的主题"]
        self.segmentedDataSource.isTitleColorGradientEnabled = true
        self.segmentedDataSource.titleNormalColor = tabColorGreen
        self.segmentedDataSource.titleSelectedColor = tabColorGreen
        self.segmentedDataSource.reloadData(selectedIndex: 0)
        self.segmentedView.dataSource = self.segmentedDataSource
        
        /// 初始化指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 30
        indicator.indicatorColor = tabColorGreen
        self.segmentedView.indicators = [indicator]
        
        //滚动列表
        self.listContainerView = JXSegmentedListContainerView(dataSource: self)
        self.segmentedView.contentScrollView = self.listContainerView?.scrollView
        self.view.addSubview(self.listContainerView!)
        self.listContainerView?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.segmentedView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        })
    }
    
    func requestNetwork() {
        
        if userHref == nil {
            return
        }
        
        var url:String?
        
        //以http开头
        if userHref!.hasPrefix("http") {
            url = userHref!
        }else {
            url = V2EXURL + userHref!
        }
    
        ZPHNetworkTool.networkRequest(url!) { (response) in
            
            DispatchQueue.global().async {
                
//                print(response)
                
                let jiDoc = Ji(htmlString: response)
                
                var partLists = [ZPHUserDetailPart]()
                //自己发布
                if let partDoc = jiDoc?.xPath("//div[@class='box']/div[@class='cell item']") {
                    
                    for cell in partDoc {
                        
                        var dic = [String:String]()
                        
                        if let spanDoc = cell.xPath("./table/tr/td/span").first {
                            dic["content"] = spanDoc.content
                        }
                        if let hrefDoc = cell.xPath("./table/tr/td/a").first?["href"] {
                            
                            dic["contentHref"] = hrefDoc
                        }
                        
                        let model = ZPHUserDetailPart(dic: dic)
                        partLists.append(model)
                    }
                }
                
                //最近回复
                if let themeDoc = jiDoc?.xPath("//div[@class='box']/div[@class='dock_area']") {

                    for cell in themeDoc {

                        var dic = [String:String]()
                        
                        if let spanDoc = cell.xPath("./table/tr/td/span").first {

                            //回复了

                            //                        print("titleDoc = \(titleDoc)")
                            dic["title"] = spanDoc.content

                            if let postDoc = spanDoc.xPath("./a").last {

                                //                            print("post = \(postDoc)")
                                dic["post"] = postDoc.content
                                dic["postUrl"] = postDoc["href"]
                            }
                        }

                        let model = ZPHUserDetail(dic: dic)
                        self.replyArray.append(model)
                    }
                }
                
                DispatchQueue.main.async {
                    
                    self.userDetailPart.partArray = partLists
                    self.userDetailReply.replyArray = self.replyArray
                    
                    //个人介绍
                    if let pageDoc = jiDoc?.xPath("//div[@class='box']/div[@class='cell']/table/tr")?.first {
                        
                        //头像
                        if let imageUrl = pageDoc.xPath("./td[@align='center']/img[@class='avatar']").first?["src"] {
                            
                            self.detailDic["imageUrl"] = imageUrl
                            let url = URL(string: "http:" + imageUrl)
                            self.headImageView.kf.setImage(with: url)
                        }
                        
                        //用户名
                        if let userName = pageDoc.xPath("./td/h1").first {
                            
                            self.detailDic["userName"] = userName.content
                            self.userNameLabel.text = "  \(userName.content ?? "")  "
                        }
                        
                        //今日活跃度排名
                        if let dau = pageDoc.xPath("./td/span/a").first {
                            
                            self.detailDic["dau"] = dau.content
                            self.dauLabel.text = "  今日活跃度排名 \(dau.content ?? "0")  "
                        }
                    }
                    
                    self.getTopViewUI()
                }
            }
        }
    }
    
    deinit {
        print("ZPHUserDetailViewController -deinit")
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

extension ZPHUserDetailViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.replyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.replyArray[indexPath.row]
        let cell = ZPHUserDetailCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ZPHUserDetailCell")
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = self.replyArray[indexPath.row]
        
        return model.cellHeight
    }
}

extension ZPHUserDetailViewController:JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
       
        switch index {
        case 0:
            self.userDetailReply.naviController = self.navigationController
            return self.userDetailReply
        default:
            self.userDetailPart.naviController = self.navigationController
            return self.userDetailPart
        }

    }
    
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        
        listContainerView?.didClickSelectedItem(at: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        
        listContainerView?.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        
        return self.segmentedDataSource.titles.count
    }
    

    
}
