//
//  ZPHHomePageController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/6/10.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHHomePageController: ZPPageViewController {
    
    /// 选择器
    var containerView : ZPPageContainerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "首页"
        
        let modality = ZPPageContainerModality()
        modality.isHaveLineContainer = true
        self.containerView = ZPPageContainerView(frame: CGRect(x: 0, y: kTopBarHeight, width: Int(kScreenWidth), height: 44), titleArray: ["最新","关注"], modality: modality)
        self.containerView.backgroundColor = UIColor.randomColor
        self.containerView.topViewAction = { index in
            self.pageChildControllerCurrentWithIndex(index: index)
        }
        self.view.addSubview(self.containerView)
    }
    
    override func pageChildControllerOfRect() -> CGRect {
        
        return CGRect(x: 0, y: CGFloat(kTopBarHeight), width: kScreenWidth, height: kScreenHeight - CGFloat(kTopBarHeight) - 44)
    }
    
    override func pageNumberOfChildController() -> NSInteger {
        
        return 2
    }
    
    override func pageChildControllerOfCurrent() -> UIViewController {
        
        let home = ZPHHomeViewController()
        return home
    }
    
    override func pageChildControllerScrollEnd(index: NSInteger) {
        
        self.containerView.modalitySelect(index: index)
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
