//
//  ZPHSettingFeedbackViewController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/4/6.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHSettingFeedbackViewController: UIViewController {
    
    private var textview:UITextView = {
        let textview = UITextView(frame: CGRect.zero)
        textview.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        textview.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        textview.autocorrectionType = UITextAutocorrectionType.no
        textview.autocapitalizationType = UITextAutocapitalizationType.none
        return textview
    }()
    
    //提交按钮
    private var submitButton:UIButton = {
        let button = UIButton()
        button.setTitle("提交", for: .normal)
        button.setTitleColor(tabColorGreen, for: .normal)
        button.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        button.layer.cornerRadius = 32
        button.layer.masksToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "意见与反馈"
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.textview);
        self.textview.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(24 + kTopBarHeight)
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(100)
        }
        
        self.submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        self.view.addSubview(self.submitButton)
        self.submitButton.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.view)
            make.left.equalTo(self.view).offset(25)
            make.right.equalTo(self.view).offset(-25)
            make.height.equalTo(64)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.textview.isFirstResponder {
            self.textview.resignFirstResponder()
        }
    }
    
    @objc func submitButtonAction() {
        
        self.navigationController?.popViewController(animated: true)
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
