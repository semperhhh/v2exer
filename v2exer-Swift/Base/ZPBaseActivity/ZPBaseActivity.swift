//
//  ZPBaseActivity.swift
//  v2exer-Swift
//
//  Created by zph on 2019/6/12.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ZPBaseActivity: NSObject {

    let activity = NVActivityIndicatorView(frame: CGRect(x: kScreenWidth / 2 - 21, y: kScreenHeight / 2 - 21, width: 42, height: 42), type: .ballPulse, color: tabColorGreen, padding: 5)
    
    override init() {
     
        super.init()
        
        let window = UIApplication.shared.keyWindow
        window?.rootViewController?.view.addSubview(activity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 开始
    func start() {
        
        self.activity.startAnimating()
    }
    
    /// 停止
    func stop() {
        
        self.activity.stopAnimating()
    }
    
    /// 是否显示状态
    ///
    /// - Returns: 状态
    func isAnimating() -> Bool {
        
        return self.activity.isAnimating
    }
}
