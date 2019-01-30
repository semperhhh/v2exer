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

class ZPHHomeViewController: UIViewController {
    
    var tableView = UITableView()
    var nmArray:[ZPHHome] = [ZPHHome]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "v2exer"
        
        tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 102
        tableView.separatorStyle = .none//分割线
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        tableView.register(ZPHHomeTableViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        
        getRequest()
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
                        self.tableView.reloadData()
                    }
                }
            }
        }
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
        
        let detail = ZPHHomeDetailViewController()
        detail.hidesBottomBarWhenPushed = true
        detail.detailURL = model.url
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
