//
//  ZPHHomeWeekView.swift
//  v2exer-Swift
//
//  Created by 张鹏辉 on 2019/4/3.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHHomeWeekView: UIView {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        
        self.viewAddUI()
    }
    
    private func viewAddUI() {
        
        let array = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
        
        let w = kScreenWidth / 7
        
        for i in 0..<array.count {
            
            let button = UIButton(frame: CGRect(x: w * CGFloat(i), y: 0, width: w, height: self.bounds.size.height))
            button.setTitle(array[i], for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            self.addSubview(button)
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
