//
//  ZPHTabBarController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2018/12/20.
//  Copyright © 2018 zph. All rights reserved.
//

import UIKit

class ZPHTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let home = ZPHHomeViewController()
        self.addChildWith(controller: home, imgName: "IconHome", itemName: "最新")
        
        let setting = ZPHHotViewController()
        self.addChildWith(controller: setting, imgName: "IconNew", itemName: "最热")

        let node = ZPHNodeViewController()
        self.addChildWith(controller: node, imgName: "IconNode", itemName: "节点")
        
        let enshrine = ZPHEnshrineViewController()
        self.addChildWith(controller: enshrine, imgName: "IconEnshrine", itemName: "收藏")

        let setting1 = ZPHSettingViewController()
        self.addChildWith(controller: setting1, imgName: "IconSetting", itemName: "设置")
        
        //kvc动态替换tabbar
//        let tabbar = ZPHTabBar()
//        setValue(tabbar, forKey: "tabBar")
//
//        tabbar.homeButton.addTarget(self, action: #selector(homeButtonAciton), for: UIControl.Event.touchUpInside)
        self.tabBar.isTranslucent = false
    }
    
    @objc func homeButtonAciton() {
        
        print("home --")
        self.selectedIndex = 2
    }
    
    //添加子控制器
    func addChildWith(controller: UIViewController, imgName: String?, itemName: String?) {
        
        let navi = ZPHNavigationController.init(rootViewController: controller)
        navi.title = itemName
        navi.tabBarItem.image = UIImage(named: imgName ?? "")
        //使用原始颜色
        navi.tabBarItem.selectedImage = UIImage(named: imgName ?? "")?.withRenderingMode(.alwaysOriginal)
        self.addChild(navi)
    }
}
