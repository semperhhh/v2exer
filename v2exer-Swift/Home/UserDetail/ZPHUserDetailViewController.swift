//
//  ZPHUserDetailViewController.swift
//  v2exer-Swift
//
//  Created by 张鹏辉 on 2019/3/7.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

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
    var detailDic = [String:String]() {
        
        didSet {
            
            if detailDic["imageUrl"] != nil {
                
            }
            
            if detailDic["userName"] != nil {
            
            }
        
            if detailDic["dau"] != nil {
            
            }
        }
    }
    
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
    
    //回复列表
    var replyTableView:UITableView = {
        let tableview = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableview.backgroundColor = UIColor.white
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "个人介绍"
        
        self.requestNetwork()
        
        self.getTopViewUI()
    }
    
    func getTopViewUI() {
        
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(kTopBarHeight)
            make.height.equalTo(200)
        }
        
        topView.addSubview(headImageView)
        headImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(topView)
            make.size.equalTo(CGSize(width: 64, height: 64))
            make.top.equalTo(34)
        }
        
        topView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headImageView.snp.bottom).offset(10)
            make.centerX.equalTo(topView)
            make.height.equalTo(24)
        }
        
        topView.addSubview(dauLabel)
        dauLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(userNameLabel)
            make.height.equalTo(24)
        }
        
        replyTableView.dataSource = self
        replyTableView.delegate = self
        replyTableView.register(ZPHUserDetailCell.classForCoder(), forCellReuseIdentifier: "ZPHUserDetailCell")
        self.view.addSubview(replyTableView)
        replyTableView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    func requestNetwork() {
        
        let url = V2EXURL + userHref!
        
        ZPHNetworkTool.networkRequest(url) { (response) in
            
            print(response)
            
            let jiDoc = Ji(htmlString: response)
            
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
            
            var dic = [String:String]()
            
            //最近回复
            if let themeDoc = jiDoc?.xPath("//div[@class='box']/div[@class='dock_area']"){
                
                for cell in themeDoc {
                    
                    if let spanDoc = cell.xPath("./table/tr/td/span").first {
                        
                        //回复了
                        if let titleDoc = spanDoc["class"] {
                            
//                            print("titleDoc = \(titleDoc)")
                            dic["title"] = titleDoc
                        }
                        
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

}

extension ZPHUserDetailViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.replyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ZPHUserDetailCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ZPHUserDetailCell")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
    }
}
