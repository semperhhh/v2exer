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
    
    private var headBackgroundView:UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.white
        return view
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
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
        return label
    }()
    
    /// 个人主页按钮
    private var userPageButton:UIButton = {
        var btn = UIButton()
        btn.setTitle("个人主页 >", for: .normal)
        btn.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.layer.cornerRadius = 14
        return btn
    }()
    
    private var model:ZPHSetting?//模型
    
    private var settingTableView:UITableView = {
        var tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
//        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    var loginButton:UIButton = {//登录按钮
        var btn = UIButton()
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.cornerRadius = 4
        btn.setTitle("登录", for: .normal)
        btn.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()
    
    //注销按钮
    var logoutButton:UIButton = {
        var btn = UIButton()
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = 4
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle("登出", for: .normal)
        btn.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()

    @objc func logoutButtonAction() {
        
        if ONCE != nil {
        
            let url = "\(V2EXURL)/signout?once=\(ONCE ?? "")"
            Alamofire.request(url, method: .get).responseString { (response) in
                
                if let reString = response.result.value {
                    
                    print("reString = \(reString)")
                    
                    self.loginButton.isHidden = false
                    self.logoutButton.isHidden = true
                    self.userNameLabel.isHidden = true
                    USERNAME = nil
                    ONCE = nil
                    self.model = nil
                    self.updataHeadBackground()
                    self.settingTableView.reloadData()
                    
                    //修改偏好
                    UserDefaults.standard.set(nil, forKey: "username")
                    UserDefaults.standard.set(nil, forKey: "once")
                    UserDefaults.standard.synchronize()
                }
            }
        }else {
            self.loginButton.isHidden = false
            self.logoutButton.isHidden = true
            self.userNameLabel.isHidden = true
            USERNAME = nil
            self.model = nil
            self.updataHeadBackground()
            self.settingTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        navigationItem.title = "设置"
        
        view.addSubview(settingTableView)
        settingTableView.dataSource = self
        settingTableView.delegate = self
        settingTableView.snp.makeConstraints { (make) in
            make.top.equalTo(kTopBarHeight)
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
        headBackgroundView.addSubview(userNameLabel)
        
        userPageButton.addTarget(self, action: #selector(userPageButtonAction), for: .touchUpInside)
        headBackgroundView.addSubview(userPageButton)
        
        headImgView.snp.makeConstraints { (make) in
            make.top.equalTo(headBackgroundView.snp.top).offset(30)
            make.left.equalTo(headBackgroundView).offset(24)
            make.size.equalTo(CGSize(width: 64, height: 64))
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(headImgView)
            make.left.equalTo(headImgView.snp.right).offset(10)
        }
        
        userPageButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(headBackgroundView)
            make.top.equalTo(headImgView.snp.bottom).offset(30)
            make.size.equalTo(CGSize(width: 300, height: 50))
        }

    }

    /// 个人主页的跳转
    @objc func userPageButtonAction() {
        
        let userDetail = ZPHUserDetailViewController()
        userDetail.userHref = "/member/" + (USERNAME ?? "")
        userDetail.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(userDetail, animated: true)
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
    
    //更新跳转
    @objc func upinstallButtonClick() {
        
        let upinstall = ZPHUpinstallViewController()
        upinstall.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(upinstall, animated: true)
    }
    
}

extension ZPHSettingViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ZPHSettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ZPHSettingTableViewCell
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "意见与反馈"
            break
        default:
            cell.textLabel?.text = "时间记录"
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard section == 0 else {
            return nil
        }
        
        let view = UIView()
        view.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
        view.addSubview(headBackgroundView)
        headBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-10)
        }
        
        headBackgroundAdd()//头像背景
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard section != section - 1 else {
            return nil
        }
        
        let view = UIView()
        view.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        view.addSubview(loginButton)
        view.addSubview(logoutButton)
        
        loginButton.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(view)
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.height.equalTo(50)
        }
        
        logoutButton.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(view)
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.height.equalTo(50)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        guard section != section - 1 else {
            return 0
        }
        
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard section == 0 else {
            return 0
        }
        
        return 216
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        switch indexPath.row {
        case 0://时间记录
            let feedback = ZPHSettingFeedbackViewController()
            feedback.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(feedback, animated: true)
            break;
        case 1://联系我
            let time = ZPHSettingTimeViewController()
            time.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(time, animated: true)
            break;
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 88
    }
}
