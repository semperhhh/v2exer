//
//  ZPHLoginViewController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/1/19.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit
import Alamofire
import Ji

class ZPHLoginViewController: UIViewController {
    
    var onceString: String?//验证码id
    var usernameStr: String?
    var passwordStr: String?
    var codeStr: String?
    var usernameBack: ((String)->())?//回调
    
    //返回按钮
    var backButton:UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(named: "back"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(backButtonAction), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    @objc func backButtonAction() {
        self.dismiss(animated: true, completion: nil)

    }
    
    //登录输入框
    var loginTextField:UITextField = {
        var textField = UITextField()
        textField.placeholder = "用户名"
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    //密码输入框
    var passTextField:UITextField = {
        var textField = UITextField()
        textField.placeholder = "密码"
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        return textField
    }()
    
    //登录按钮
    var loginButton:UIButton = {
        var btn = UIButton()
        btn.setTitle("login", for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(loginButtonAction), for: UIControl.Event.touchUpInside)
        btn.backgroundColor = UIColor.red
        return btn
    }()
    
    //验证码图片
    var codeImageView:UIImageView = {
        var imgView = UIImageView()
        return imgView
    }()
    
    //验证码输入
    var codeTextField:UITextField = {
        var textField = UITextField()
        textField.placeholder = "验证码"
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    
    @objc func loginButtonAction() {
        print("login")
        view.endEditing(true)
    
        if loginTextField.text?.count == 0 || passTextField.text?.count == 0 || codeTextField.text?.count == 0{
            
            print("请输入用户名和密码")
            return
        }
        
        //登录网络请求
        let urlString = "\(V2EXURL)/signin"
        var param = [String:String]()
        
        param[usernameStr!] = loginTextField.text
        param[passwordStr!] = passTextField.text
        param["once"] = onceString
        param["next"] = "/"
        param[codeStr!] = codeTextField.text
        
        var dict = MOBILE_CLIENT_HEADERS
        //为安全，此处使用https
        dict["Referer"] = "https://v2ex.com/signin"
        
        Alamofire.request(urlString, method: .post, parameters: param, headers: dict).responseString { (response) in
            
            if let reString = response.result.value {
//                print("reString ------------------------------ = \(reString)")
                
                let jiDoc = Ji(htmlString: reString)
                if let avatarImg = jiDoc?.xPath("//*[@id='Top']/div/div/table/tr/td[3]/a[1]/img[1]")?.first {
                    
                    if let username = avatarImg.parent?["href"]{
                        if username.hasPrefix("/member/") {
                            let username = username.replacingOccurrences(of: "/member/", with: "")
                            print("username = \(username)")
                            
                            self.dismiss(animated: true, completion: nil)
                            
                            //username 传到setting界面 循环引用
                            if (self.usernameBack != nil) {
                                self.usernameBack!(username)
                            }
                        }
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        getUI()
        
        requestSignin()
    }
    
    //MARK:加载验证码
    func requestSignin() {
        
        let urlString = "\(V2EXURL)/signin"
//        let jiDoc = Ji(htmlURL: URL(string: urlString)!)
//        let titleNode = jiDoc?.xPath("//head/title")?.first
//        print(titleNode?.content)
        
        Alamofire.request(urlString).responseString { (respose) in
            
            if let reString = respose.result.value {
                
                let jiDoc = Ji(htmlString: reString)
                
                self.usernameStr = jiDoc?.xPath("//*[@id='Wrapper']/div/div[3]/div[2]/div[2]/form/table/tr[1]/td[2]/input[@class='sl']")?.first?["name"]
                self.passwordStr = jiDoc?.xPath("//*[@id='Wrapper']/div/div[3]/div[2]/div[2]/form/table/tr[2]/td[2]/input[@class='sl']")?.first?["name"]
                self.codeStr = jiDoc?.xPath("//*[@id='Wrapper']/div/div[3]/div[2]/div[2]/form/table/tr[3]/td[2]/input[@class='sl']")?.first?["name"]
                
                if let title = jiDoc?.xPath("//head/title")?.first {
                    print("title = \(title)")
                }
                
                if let once = jiDoc?.xPath("//*[@name='once']")?.first?["value"] {
                    print("once = \(once)")
                    self.onceString = once
                    let codeUrl = "\(V2EXURL)/_captcha?once=\(once)"
                    Alamofire.request(codeUrl).responseData(completionHandler: { (dataResp) in
                        self.codeImageView.image = UIImage(data: dataResp.data!)
                    })
                }
            }
        }
    }
    
    deinit {
        
        print("ZPHLoginViewController deinit ~")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //收起键盘
        view.endEditing(true)
    }
    
    //MARK:添加控件
    func getUI() {
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { (mark) in
            mark.top.equalTo(30)
            mark.left.equalTo(25)
            mark.size.equalTo(CGSize.init(width: 45, height: 45))
        }
        
        view.addSubview(loginTextField)
        loginTextField.snp.makeConstraints { (mark) in
            mark.centerX.equalTo(view)
            mark.top.equalTo(100)
            mark.width.equalTo(200)
            mark.height.equalTo(50)
        }
        
        view.addSubview(passTextField)
        passTextField.snp.makeConstraints { (mark) in
            mark.centerX.equalTo(view)
            mark.top.equalTo(loginTextField.snp_bottomMargin).offset(50)
            mark.width.equalTo(200)
            mark.height.equalTo(50)
        }
        
        view.addSubview(codeImageView)
        codeImageView.snp.makeConstraints { (mark) in
            mark.centerX.equalTo(view)
            mark.top.equalTo(passTextField.snp_bottomMargin).offset(50)
            mark.width.equalTo(200)
            mark.height.equalTo(50)
        }
        
        view.addSubview(codeTextField)
        codeTextField.snp.makeConstraints { (mark) in
            mark.centerX.equalTo(view)
            mark.top.equalTo(codeImageView.snp_bottomMargin).offset(50)
            mark.width.equalTo(200)
            mark.height.equalTo(50)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (mark) in
            mark.centerX.equalTo(view)
            mark.top.equalTo(codeTextField.snp_bottomMargin).offset(50)
            mark.width.equalTo(200)
            mark.height.equalTo(50)
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
