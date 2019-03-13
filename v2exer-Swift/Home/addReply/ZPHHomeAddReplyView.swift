//
//  ZPHHomeAddReplyView.swift
//  v2exer-Swift
//
//  Created by 张鹏辉 on 2019/3/12.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHHomeAddReplyView: UIView {
    
    //textview
    var textview:UITextView = {
        let textview = UITextView()
        textview.layer.cornerRadius = 5
        textview.layer.borderWidth = 1
        textview.layer.borderColor = UIColor.gray.cgColor
        textview.text = "添加回复..."
        textview.font = UIFont.systemFont(ofSize: 16)
        return textview
    }()
    
    //回复回调
    var replyBlock:((_ replyString: String) -> Void)?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        textview.delegate = self
        self.addSubview(textview)
        textview.snp.makeConstraints { (make) in
            make.top.equalTo(2)
            make.left.equalTo(2)
            make.right.equalTo(self.snp.right).offset(-2)
            make.bottom.equalTo(self.snp.bottom).offset(-2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension ZPHHomeAddReplyView:UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textview.text = nil
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {//回车
            
            print(text)
            
            textview.endEditing(true)
            
            //回调 发送回复请求
            if (self.replyBlock != nil) {
                self.replyBlock!(textView.text)
            }
            
            textView.text = nil//置为空
        }
        
        return true
    }
}
