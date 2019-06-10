//
//  ZPHNodeViewController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2018/12/20.
//  Copyright © 2018 zph. All rights reserved.
//

import UIKit
import Alamofire
import Ji

class ZPHNodeViewController: UIViewController {
    
    var tableview:UITableView = {
        var tableview = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableview.showsVerticalScrollIndicator = false
        return tableview
    }()
    
    //数组
    var nodeArray = [ZPHNodeModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "节点"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableview.dataSource = self
        tableview.delegate = self
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (mark) in
            mark.top.equalTo(kTopBarHeight)
            mark.left.right.bottom.equalTo(self.view)
        }
        tableview.register(ZPHNodeTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        archiveRead()
    }
    
    //MARK:存
    private func archiveSave() {
        
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true).last
        let filePath = documentPath! + "/nodes"
        
//        let nodeArray = try! NSKeyedArchiver.archivedData(withRootObject: self.nodeArray, requiringSecureCoding: true) as NSData
        
        print("\(NSKeyedArchiver.archiveRootObject(self.nodeArray, toFile: filePath))")
    }
    
    //MARK:取
    private func archiveRead() {
        
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true).last
        let filePath = documentPath! + "/nodes"
        
        if let mo = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) {

            self.nodeArray = mo as! [ZPHNodeModel]
            self.tableview.reloadData()
        }else {
            print("mo = error")
            getRequest()
        }
    }
    
    func getRequest() {
        
        let url = "\(V2EXURL)/?tab=members"
        Alamofire.request(url, method: .get).responseString { (response) in
            
            if let responseStr = response.result.value {
                
//                print("responseStr =\(responseStr)")
                
                let jiDoc = Ji(htmlString: responseStr)
                if let nodes:[JiNode] = jiDoc?.xPath("//*[@class='box']/div/table/tr") {
//                    print("nodes = \(nodes)")
                    
                    for node in nodes {

                        if let nodeFade = node.xPath("./td/span[@class='fade']").first {
                            
                            var types = [[String:Any]]()
                            
                            if let nodeType:[JiNode] = node.xPath("./td/a") {
                                
                                for (i,type) in nodeType.enumerated() {
                                    var typeDic = [String:String]()
                                    typeDic["name"] = type.content!
//                                    types.append(type.content!)
                                    
                                    if let nodeA = node.xPath("./td/a[\(i + 1)]").first?["href"] {
//                                        print("nodea = \(nodeA)")
                                        typeDic["uri"] = nodeA
                                    }
                                    types.append(typeDic)
                                }
                            }
                            
                            let dic:[String:Any] = ["nodeFade":nodeFade.content!,
                                                       "types":types]
                            
//                            print("nodeDic = \(dic)")
                            let model:ZPHNodeModel = ZPHNodeModel(dic: dic)
                            self.nodeArray.append(model)
                        }
                    }
                    self.tableview.reloadData()
                    self.archiveSave()
                }
            }
        }
    }
    
    deinit {
        
        print("ZPHNodeViewController --- deinit")
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

extension ZPHNodeViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.nodeArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.nodeArray[indexPath.section]
    
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ZPHNodeTableViewCell
        let cell = ZPHNodeTableViewCell(style: .default, reuseIdentifier: "cell")
        cell.model = model
        cell.collectionCellBack = { (name, uri) in
            
            print("点击的类型 -- \(name)")
            self.typeRequest(name, uri)
        }
        return cell
    }
    
    //类型请求跳转
    func typeRequest(_ name:String, _ uri:String) {
        
        let detail = ZPHNodeDetailViewController()
        detail.hidesBottomBarWhenPushed = true
        detail.name = name
        detail.uri = uri
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.pushViewController(detail
            , animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let model = self.nodeArray[section]
        
        let view = UIView()
        view.backgroundColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        
        let lab = UILabel(frame: CGRect.init(x: 0, y: 0, width: 200, height: 40))
        lab.text = " \(model.nodeFade ?? "")"
        lab.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.semibold)
        view.addSubview(lab)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = self.nodeArray[indexPath.section]
        var rowNum:Int = model.types!.count / 4
        if model.types!.count % 4 != 0 {
            rowNum += 1
        }

        return CGFloat(Int(kScreenWidth / 4) * rowNum)
    }

}
