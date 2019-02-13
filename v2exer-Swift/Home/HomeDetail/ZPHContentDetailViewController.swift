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
import NVActivityIndicatorView

class ZPHContentDetailViewController: UIViewController {
    
    var detailURL:String?
    var tableview:UITableView = {
        var tableview = UITableView()
        return tableview
    }()
    
    var contentDic = [String:Any]()//头部内容字典
    var replyArray = [ZPHContentDetailModel]()//回复数组
    var activityIndicatorView:NVActivityIndicatorView = {
        let activity = NVActivityIndicatorView(frame: CGRect.zero, type: NVActivityIndicatorType.ballRotateChase, color: tabColorGreen, padding: 2.0)
        return activity
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "内容"
        self.view.backgroundColor = UIColor.white
        
        tableview.dataSource = self
        tableview.delegate = self
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(kTopBarHeight)
            make.left.right.bottom.equalTo(self.view)
        }
        tableview.register(ZPHContentTitleTableViewCell.classForCoder(), forCellReuseIdentifier: "cellTitle")
        tableview.register(ZPHContentTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
            
        let footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        let lab = UILabel.init(frame: CGRect(x: 0, y: 1, width: kScreenWidth, height: 29))
        lab.text = "没有新的回复"
        lab.textColor = UIColor.gray
        lab.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        lab.textAlignment = NSTextAlignment.center
        footerView.addSubview(lab)
        tableview.tableFooterView = footerView
        
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self.view)
            make.size.equalTo(CGSize(width: 80, height: 40))
        }
        activityIndicatorView.startAnimating()
    
        getRequest()
    }
    
    private func getRequest() {
        
        Alamofire.request(detailURL!).responseString { (response) in
            
            if let reString = response.result.value {
                
                print("reString = \(reString)")
                
                let jiDoc = Ji(htmlString: reString)
                
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
                        
                        let htmlText = "<head><style>img{width:\(kScreenWidth - 20) !important;height:auto}</style></head>\(contentTitle.debugDescription)"
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
                        
                        print("cellDict -- \(cellDict)")
                        
                        let model = ZPHContentDetailModel(dic: cellDict)
                        self.replyArray.append(model)
                    }
                }
                
                self.tableview.reloadData()
                if self.activityIndicatorView.isAnimating {
                    self.activityIndicatorView.stopAnimating()
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
            return cell

        }
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
            
            print("cellHeight ------ \(String(describing: cellHeight))")
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
