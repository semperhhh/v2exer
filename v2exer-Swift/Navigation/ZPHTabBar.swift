//
//  ZPHTabBar.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2018/12/21.
//  Copyright © 2018 zph. All rights reserved.
//

import UIKit

class ZPHTabBar: UITabBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //添加主页按钮
        self.addSubview(homeButton)
        self.tintColor = UIColor.black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let Width = bounds.width / 5.0
        var Height:CGFloat {
            if iPhoneX {
                return 49
            }else {
                return self.bounds.height
            }
        }
        var index = 0
        
        //遍历控件
        for subview in subviews {
            
            if subview.isKind(of: NSClassFromString("UITabBarButton")!) {
                
                subview.frame = CGRect.init(x: Width * CGFloat(index), y: 0, width: Width, height: Height)
                
                index += 1
                
                if index == 2 {
                    
                    homeButton.frame = CGRect.init(x: Width * CGFloat(index), y: 0, width: Width, height: Height)
                    index += 1
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var homeButton:UIButton = {

        let button = UIButton()
        button.setImage(UIImage(named: "IconAdd"), for: UIControl.State.normal)
        
        return button
    }()

    //重写hitTest方法,去监听发布按钮的点击,目的是为了让凸出的部分点击也有反应
    /*
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if self.isHidden == false {
            
            let newP = self.convert(point, to: homeButton)
            
            if homeButton.point(inside: newP, with: event) {
                return homeButton
            }else {
                return super.hitTest(point, with: event)
            }
        }else {
            return super.hitTest(point, with: event)
        }
    }
 */
}
