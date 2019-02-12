//
//  ZPHSettingViewController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2018/12/20.
//  Copyright © 2018 zph. All rights reserved.
//

import UIKit
import Alamofire

class ZPHSettingViewController: UIViewController {
    
    private var headBackgroundView:UIImageView = {
        var imgView = UIImageView()
        imgView.backgroundColor = UIColor.white
        return imgView
    }()
    
    private var headImgView:UIImageView = {//头像
        var imgView = UIImageView()
        imgView.backgroundColor = UIColor.white
        imgView.layer.cornerRadius = 32
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    private var userNameLabel:UILabel = {//用户名
        var label = UILabel()
        return label
    }()
    
    private var model:ZPHSetting?//模型
    
    private var settingTableView:UITableView = {
        var tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        return tableView
    }()
    
    var loginButton:UIButton = {//登录按钮
        var btn = UIButton()
        btn.backgroundColor = UIColor.gray
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.cornerRadius = 4
        btn.setTitle("请登录", for: .normal)
        btn.addTarget(self, action: #selector(loginButtonAction), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    //注销按钮
    var logoutButton:UIButton = {
        var btn = UIButton()
        btn.backgroundColor = UIColor.gray
        btn.layer.cornerRadius = 4
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle("logout", for: .normal)
        btn.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        return btn
    }()

    @objc func logoutButtonAction() {
        
//        if ONCE != nil {
        
            let url = "\(V2EXURL)/signout?once=\(ONCE ?? "")"
            Alamofire.request(url, method: .get).responseString { (response) in
                
                if let reString = response.result.value {
                    
                    print("reString = \(reString)")
                    
                    self.loginButton.isHidden = false
                    self.logoutButton.isHidden = true
                    self.userNameLabel.isHidden = true
                    USERNAME = nil
                    self.model = nil
                    self.updataHeadBackground()
                    self.settingTableView.reloadData()
                }
            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        navigationItem.title = "设置"
        
        view.addSubview(headBackgroundView)
        headBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(kTopBarHeight)
            make.left.right.equalTo(view)
            make.height.equalTo(200)
        }
        
        headBackgroundAdd()//头像背景
        
        view.addSubview(settingTableView)
        settingTableView.dataSource = self
        settingTableView.delegate = self
        settingTableView.snp.makeConstraints { (make) in
            make.top.equalTo(headBackgroundView.snp_bottomMargin)
            make.left.right.bottom.equalTo(view)
        }
        
        settingTableView.register(ZPHSettingTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        getRequest()
    }
    
    private func getRequest() {
        
        if USERNAME == nil{
            loginButton.isHidden = false
            logoutButton.isHidden = true
            userNameLabel.isHidden = true
            return
        }else {
            loginButton.isHidden = true
            logoutButton.isHidden = false
            userNameLabel.isHidden = false
        }
        
        Alamofire.request(SETTINGURL, method: .get, parameters:["username":USERNAME!]).responseJSON { (response) in
            
            print("result == \(response.result)")
            
            if let jsonValue = response.result.value as? [String:Any] {
                
                print(jsonValue)
                self.model = ZPHSetting(dic: jsonValue)
                self.updataHeadBackground()
                self.settingTableView.reloadData()
            }
        }
    }
    
    //MARK:更新头像
    private func updataHeadBackground() {
        
        userNameLabel.text = model?.username
        
        let url = URL(string: "http:\(model?.avatar_normal ?? "")")
        headImgView.kf.setImage(with: url)
    }
    
    //MARK:头像背景
    private func headBackgroundAdd() {
        
        headBackgroundView.addSubview(headImgView)
        headImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(headBackgroundView)
            make.top.equalTo(headBackgroundView.snp.top).offset(30)
            make.size.equalTo(CGSize(width: 64, height: 64))
        }
        
        headBackgroundView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headImgView.snp_bottomMargin).offset(20)
            make.centerX.equalTo(headBackgroundView)
        }
        
        view.addSubview(loginButton)//位置
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel.snp_bottomMargin).offset(20)
            make.centerX.equalTo(headBackgroundView)
            make.height.equalTo(28)
            make.width.equalTo(70)
        }
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel.snp_bottomMargin).offset(20)
            make.centerX.equalTo(headBackgroundView)
            make.height.equalTo(28)
            make.width.equalTo(70)
        }
    }
    
    @objc func loginButtonAction() {
        
        print("please login")
        let login = ZPHLoginViewController()
        login.usernameBack = {(username) -> () in
            //请求用户信息
            USERNAME = username
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.synchronize()
            self.getRequest()
        }
        navigationController?.present(login, animated: true, completion: nil)
    }
}

extension ZPHSettingViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ZPHSettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ZPHSettingTableViewCell
        switch indexPath.section {
        case 0:
            cell.nameTitle = model?.github
            break
        case 1:
            cell.nameTitle = model?.twitter
            break
        case 2:
            cell.nameTitle = model?.url
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "GITHub"
        case 1:
            return "TWITTRE"
        case 2:
            return "个人主页"
        default:
            return "other"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
