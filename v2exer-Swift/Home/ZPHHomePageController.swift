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
        
        let rightBtn = UIBarButtonItem(image: UIImage(named: "caution"), style: .plain, target: self, action: #selector(rightButtonAction))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        let modality = ZPPageContainerModality()
        modality.isHaveLineContainer = true
        modality.selectColor = tabColorGreen
        self.containerView = ZPPageContainerView(frame: CGRect(x: 0, y: kTopBarHeight, width: Int(kScreenWidth), height: 44), titleArray: ["最新", "二手交易", "北京", "程序员"], modality: modality)
        self.containerView.backgroundColor = UIColor.white
        self.containerView.topViewAction = { index in
            self.pageChildControllerCurrentWithIndex(index: index)
        }
        self.view.addSubview(self.containerView)
    }
    
    // MARK: 消息
    @objc func rightButtonAction() {
        
        let caution = ZPHCautionViewController()
        self.navigationController?.pushViewController(caution, animated: true)
    }
    
    override func pageChildControllerOfRect() -> CGRect {
        
        return CGRect(x: 0, y: CGFloat(kTopBarHeight) + 44, width: kScreenWidth, height: kScreenHeight - CGFloat(kTopBarHeight) - 44 - CGFloat(kTabBarHeight))
    }
    
    override func pageNumberOfChildController() -> NSInteger {
        
        return 4
    }
    
    override func pageChildControllerOfCurrent(index: NSInteger) -> UIViewController {
        
        if index == 0 {
            
            let home = ZPHHomeViewController()
            return home
            
        }else if index == 1 {
            
//            name = 二手交易 uri = /go/all4all
            let nodeDetail = ZPHNodeDetailViewController()
            nodeDetail.name = "二手交易"
            nodeDetail.uri = "/go/all4all"
            return nodeDetail
            
        }else if index == 2 {
            
//            name = 北京 uri = /go/beijing
            let nodeDetail = ZPHNodeDetailViewController()
            nodeDetail.name = "北京"
            nodeDetail.uri = "/go/beijing"
            return nodeDetail
            
        }else if index == 3 {
            
//            name = 程序员 uri = /go/programmer
            let nodeDetail = ZPHNodeDetailViewController()
            nodeDetail.name = "程序员"
            nodeDetail.uri = "/go/programmer"
            return nodeDetail
            
        }else {
            
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor
            return vc
        }
    }
    
    override func pageChildControllerScrollEnd(index: NSInteger) {
        
        self.containerView.modalitySelect(index: index)
    }
    
    override func pageChildControllerScrolling(scrollOffset: CGFloat) {

        self.containerView.modalityScroll(offset: scrollOffset)
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
