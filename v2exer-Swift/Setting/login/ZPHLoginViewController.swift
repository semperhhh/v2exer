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
        
        let window = UIApplication.shared.keyWindow
        window?.rootViewController = ZPHTabBarController()
    }
    
    //logo
    var logoImgView:UIImageView = {
        var imgView = UIImageView()
        imgView.backgroundColor = UIColor.white
        imgView.image = UIImage(named: "logo")
        return imgView
    }()
    
    //登录输入框
    var loginTextField:ZPHLoginTextField = {
        var textField = ZPHLoginTextField()
        textField.placeholder = "用户名"
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        return textField
    }()
    
    //密码输入框
    var passTextField:ZPHLoginTextField = {
        var textField = ZPHLoginTextField()
        textField.placeholder = "密码"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        return textField
    }()
    
    //登录按钮
    var loginButton:UIButton = {
        var btn = UIButton()
        btn.setTitle("点击登录", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(loginButtonAction), for: UIControl.Event.touchUpInside)
        btn.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
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
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        return textField
    }()
    
    var activity = ZPBaseActivity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        getUI()
        
        requestSignin()
    }
    
    @objc func loginButtonAction() {
        
        self.activity.start()
        
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
                            
                            self.activity.stop()
                            
                            let username = username.replacingOccurrences(of: "/member/", with: "")
                            print("username = \(username)")
                            
                            self.dissLoginView()
                            
                            USERNAME = username
                            UserDefaults.standard.set(username, forKey: "username")
                            UserDefaults.standard.synchronize()
                            
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
    
    internal func dissLoginView() {
        
        let window = UIApplication.shared.keyWindow
        window?.rootViewController = ZPHTabBarController()
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
                    ONCE = once

                    let codeUrl = "\(V2EXURL)/_captcha?once=\(once)"
                    Alamofire.request(codeUrl).responseData(completionHandler: { (dataResp) in
                        self.codeImageView.image = UIImage(data: dataResp.data!)
                    })
                    
                    //once存偏好
                    UserDefaults.standard.set(once, forKey: "once")
                    UserDefaults.standard.synchronize()
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
        
        view.addSubview(logoImgView)
        logoImgView.snp.makeConstraints { (mark) in
            mark.top.equalTo(self.backButton.snp.bottom).offset(10)
            mark.centerX.equalTo(self.view)
            mark.size.equalTo(CGSize(width: 280, height: 120))
        }
        
        view.addSubview(loginTextField)
        loginTextField.snp.makeConstraints { (mark) in
            mark.centerX.equalTo(view)
            mark.top.equalTo(logoImgView.snp.bottom).offset(10)
            mark.width.equalTo(kScreenWidth - 40)
            mark.height.equalTo(40)
        }
        
        view.addSubview(passTextField)
        passTextField.snp.makeConstraints { (mark) in
            mark.centerX.equalTo(view)
            mark.top.equalTo(loginTextField.snp_bottomMargin).offset(30)
            mark.width.equalTo(loginTextField)
            mark.height.equalTo(40)
        }
        
        view.addSubview(codeImageView)
        codeImageView.snp.makeConstraints { (mark) in
            mark.centerX.equalTo(view)
            mark.top.equalTo(passTextField.snp_bottomMargin).offset(30)
            mark.width.equalTo(loginTextField)
            mark.height.equalTo(50)
        }
        
        view.addSubview(codeTextField)
        codeTextField.snp.makeConstraints { (mark) in
            mark.centerX.equalTo(view)
            mark.top.equalTo(codeImageView.snp_bottomMargin).offset(30)
            mark.left.equalTo(self.codeImageView).offset(40)
            mark.right.equalTo(self.codeImageView).offset(-40)
            mark.height.equalTo(40)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (mark) in
            mark.centerX.equalTo(view)
            mark.top.equalTo(codeTextField.snp_bottomMargin).offset(50)
            mark.width.equalTo(self.codeTextField)
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

class ZPHLoginTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let lineView = UIView()
        lineView.backgroundColor = tabColorGreen
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-1)
            make.left.right.equalTo(self)
            make.height.equalTo(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
