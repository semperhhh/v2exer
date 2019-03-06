//
//  ZPHUpinstallViewController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/2/28.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHUpinstallViewController: UIViewController {
    
    var tableview:UITableView = {
        let tableview = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableview.backgroundColor = UIColor.white
        tableview.rowHeight = 60
        tableview.separatorStyle = .none
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "更新"
        self.view.backgroundColor = UIColor.white
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(ZPHUpinstallTableViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(kTopBarHeight)
            make.left.right.bottom.equalTo(self.view)
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

extension ZPHUpinstallViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ZPHUpinstallTableViewCell(style: .default, reuseIdentifier: "cellId")
        
        switch indexPath.row {
        case 0:
            cell.contentLabel.text = "个人设置"
            break
        case 1:
            cell.contentLabel.text = "组件设置"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        print(indexPath.row)
    }
    
}
