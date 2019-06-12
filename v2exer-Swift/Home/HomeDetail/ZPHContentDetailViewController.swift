//
//  ZPHContentDetailViewController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/1/31.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit
import Alamofire
import Ji

class ZPHContentDetailViewController: UIViewController {
    
    var detailURL:String? {
        didSet {
            
            if detailURL != nil {
                
                if !detailURL!.hasPrefix("http") {
                    detailURL = V2EXURL + detailURL!
                }
            }
        }
    }
    
    var tableview:UITableView = {
        var tableview = UITableView()
        tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableview
    }()
    
    var contentDic = [String:Any]()//头部内容字典
    var replyArray = [ZPHContentDetailModel]()//回复数组
    
    var topicsArr = [[String:String]]()//top操作数组
    var rightBtn:UIBarButtonItem = UIBarButtonItem()

    /// 回复
    var addReplyView:ZPHHomeAddReplyView = {
        let reply = ZPHHomeAddReplyView()
        return reply
    }()
    
    var activity = ZPBaseActivity()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "内容"
        self.view.backgroundColor = UIColor.white
        
        rightBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction))

        tableview.dataSource = self
        tableview.delegate = self
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(kTopBarHeight)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-kTabBarHeight)
        }
        tableview.register(ZPHContentTitleTableViewCell.classForCoder(), forCellReuseIdentifier: "cellTitle")
        tableview.register(ZPHContentTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")

        /* 添加footer会导致界面闪一下
        let footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        let lab = UILabel.init(frame: CGRect(x: 0, y: 1, width: kScreenWidth, height: 29))
        lab.text = "没有新的回复"
        lab.textColor = UIColor.gray
        lab.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        lab.textAlignment = NSTextAlignment.center
        footerView.addSubview(lab)
        tableview.tableFooterView = footerView
        */

        getRequest()

        //回复
        addReplyView.replyBlock = {[weak self] replyString in

            self?.getReplyRequest(replyString)
        }
        self.view.addSubview(addReplyView)
        addReplyView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(44 + kBottomSafeHeight)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden), name: UIResponder.keyboardWillHideNotification, object: nil)

        //点击取消键盘
        let tap = UITapGestureRecognizer(target: self, action: #selector(topAction))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func getReplyRequest(_ replyString: String) {
    
        print("replyString = \(replyString)")
        
        //菊花转两秒
    }
    
    @objc func topAction() {
        
        self.view.endEditing(true)
    }
    
    //键盘隐藏
    @objc func keyboardWasHidden(notify:NSNotification) {
        
        guard notify.userInfo != nil else {
            return
        }
        
        let keyboardFrame:CGRect = notify.userInfo?["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        
        print("ZPHContentDetailViewController keyboardFrame = \(keyboardFrame)")
        
        UIView.animate(withDuration: 2.0) {
            self.addReplyView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(self.view)
                make.height.equalTo(44 + kBottomSafeHeight)
                make.top.equalTo(keyboardFrame.origin.y - 44 - CGFloat(kBottomSafeHeight))
            }
            self.view.layoutIfNeeded()
        }
    }
    
    //键盘展示和隐藏
    @objc func keyboardWasShown(notify:NSNotification) {
        
        guard notify.userInfo != nil else {
            return
        }
        
        let keyboardFrame:CGRect = notify.userInfo?["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        
        print("ZPHContentDetailViewController keyboardFrame = \(keyboardFrame)")
    
        UIView.animate(withDuration: 2.0) {
            self.addReplyView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(self.view)
                make.height.equalTo(44)
                make.top.equalTo(keyboardFrame.origin.y - 44)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func rightButtonAction() {
        
        let alertViewC = UIAlertController(title: "操作", message: "", preferredStyle: .actionSheet)
        
        for topics in topicsArr {
            
            let collect:UIAlertAction = UIAlertAction.init(title: topics["content"], style: .default) { (alert) in
                
                let url = V2EXURL + (topics["url"] ?? "")
                Alamofire.request(url, method: .get).responseString(completionHandler: { (response) in
                    
                    if let reString = response.result.value {
                        
//                        print(reString)
                    }
                })
            }
            alertViewC.addAction(collect)
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertViewC.addAction(cancel)
        
        self.present(alertViewC, animated: true, completion: nil)
    }
    
    private func getRequest() {
        
        self.activity.start()
        
        Alamofire.request(detailURL!).responseString { (response) in
            
            DispatchQueue.global().async {
                
                if let reString = response.result.value {
                    
                    //                print("reString = \(reString)")
                    
                    let jiDoc = Ji(htmlString: reString)
                    
                    //收藏按钮
                    if let topicsDoc = jiDoc?.xPath("//div[@class='box']/div[@class='topic_buttons']/a") {
                        
                        //加入收藏
                        if let href = topicsDoc.first?["href"] {
                            
                            var hrefDic = [String:String]()
                            hrefDic["url"] = href
                            hrefDic["content"] = topicsDoc.first?.content
                            self.topicsArr.append(hrefDic)
                        }
                        
                        /* 忽略主题
                         if let href = topicsDoc.last?["href"] {
                         
                         var hrefDic = [String:String]()
                         hrefDic["url"] = href
                         hrefDic["content"] = topicsDoc.last?.content
                         self.topicsArr.append(hrefDic)
                         }
                         */
            
                        //                    print("topicsDoc.first?.content = \(topicsDoc.first?.content)")
                        //                    print("topicsDoc.last?.content = \(topicsDoc.last?.content)")
                    }
                    
                    if let boxDoc = jiDoc?.xPath("//div[@class='box'][@style]")?.first {
                        
                        if let headTitle = boxDoc.xPath("./div/h1").first {
                            
                            let htmlText = headTitle.debugDescription
                            do {
                                let attrStr = try NSMutableAttributedString(data: htmlText.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                                
                                //                            self.headLabel.attributedText = attrStr
                                self.contentDic["head"] = attrStr
                            } catch  {
                                print("error")
                            }
                        }
                        
                        if let contentTitle = boxDoc.xPath("./div[@class='cell']/div/div[@class='markdown_body']").first {
                            
                            let htmlText = "<head><style>img{width:\(kScreenWidth - 20) !important;height:auto}p{font-size:20px;}</style></head>\(contentTitle.debugDescription)"
                            do {
                                let attrStr = try NSMutableAttributedString(data: htmlText.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                                
                                //                            self.contentLabel.attributedText = attrStr
                                self.contentDic["content"] = attrStr
                            } catch  {
                                print("error")
                            }
                        }else if let contentTitle = boxDoc.xPath("./div[@class='cell']/div[@class='topic_content']").first {
                            
                            let htmlText = "<head><style>img{width:\(kScreenWidth - 20) !important;height:auto}</style></head>\(contentTitle.debugDescription)"
                            do {
                                let attrStr = try NSMutableAttributedString(data: htmlText.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                                
                                //                            self.contentLabel.attributedText = attrStr
                                self.contentDic["content"] = attrStr
                            } catch  {
                                print("error")
                            }
                        }
                    }
                    
                    if let cellDoc:[JiNode] = jiDoc?.xPath("//div[@class='box']/div[@class='cell'][@id]/table/tr") {
                        
                        var cellDict = [String:Any]()
                        for cell in cellDoc {
                            
                            if let cellReply = cell.xPath("./td/div[@class='reply_content']").first {
                                
                                //                            print("cellReply -- \(cellReply.content!)")
                                cellDict["reply"] = cellReply.content!
                            }
                            
                            if let cellTime = cell.xPath("./td/span[@class='ago']").first {
                                
                                //                            print("cellTime -- \(cellTime.content!)")
                                cellDict["time"] = cellTime.content!
                            }
                            
                            if let cellImg = cell.xPath("./td/img").first?["src"] {
                                
                                //                            print("cellImg -- \(cellImg)")
                                cellDict["img"] = cellImg
                            }
                            
                            if let cellUser = cell.xPath("./td/strong/a").first {
                                
                                cellDict["userName"] = cellUser.content//用户名
                                cellDict["userHref"] = cellUser["href"]//地址
                            }
                            
                            //                        print("cellDict -- \(cellDict)")
                            
                            let model = ZPHContentDetailModel(dic: cellDict)
                            self.replyArray.append(model)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        //添加按钮
                        self.navigationItem.rightBarButtonItem = self.rightBtn
                
                        self.tableview.reloadData()
                        
                        self.activity.stop()
                    }
                }
            }
        }
    }
    
    deinit {
        print("ZPHContentDetailViewController -- deinit")
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

extension ZPHContentDetailViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.replyArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:

            let cell = ZPHContentTitleTableViewCell(style: .default, reuseIdentifier: "cellTitle")
            cell.contentDic = contentDic
            return cell

        default:

            let model = self.replyArray[indexPath.row - 1]
            let cell = ZPHContentTableViewCell(style: .default, reuseIdentifier: "cell")
            cell.model = model
            cell.imgButtonActionBlock = {
                
                print("头像点击回调跳转个人详情")
                self.goUserDetail(model.userHref)
            }
            return cell

        }
    }
    
    //跳转个人详情
    func goUserDetail(_ userHref:String?) {
        
        if userHref == nil {
            return
        }
        
        let userDetail = ZPHUserDetailViewController()
        userDetail.userHref = userHref
        self.navigationController?.pushViewController(userDetail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            
            var cellHeight : CGFloat?
            let headAttr = contentDic["head"] as? NSMutableAttributedString
            headAttr?.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 28)], range: NSRange(location: 0, length: (headAttr?.length ?? 0)))
            let contentAttr = contentDic["content"] as? NSMutableAttributedString
            contentAttr?.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: (contentAttr?.length ?? 0)))
            
            if let boundingHead = headAttr?.boundingRect(with: CGSize(width: kScreenWidth - 20, height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil) {
                
                cellHeight = boundingHead.height + 20
            }
            
            if let boundingRect = contentAttr?.boundingRect(with: CGSize(width: kScreenWidth - 20, height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil) {
                
                cellHeight = boundingRect.height + 20 + (cellHeight ?? 0)
            }
            
//            print("cellHeight ------ \(String(describing: cellHeight))")
            return cellHeight ?? 0
        default:
            let model = self.replyArray[indexPath.row - 1]
            
            return model.cellHeight ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.deselectRow(at: indexPath, animated: true)
    }
}
