//
//  ZPPageViewController.swift
//  pageController
//
//  Created by zhangpenghui on 2019/6/6.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPPageViewController: UIViewController {
    
    /// 滚动
    var scrollView = UIScrollView()
    
    /// 当前选中索引
    var selectIndex: NSInteger = 0
    
    /// 当前选中位置x
    var selectOffsetx: CGFloat = 0
    
    /// 当前选中偏移位置
    var selectPage:NSInteger = 0
    
    /// frame缓存
    var cacheFrame = [NSInteger:CGRect]()
    
    /// 控制器缓存
    var cacheController = [NSInteger:UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 子控制器个数
        let numb = self.pageNumberOfChildController()
        let rect = self.pageChildControllerOfRect()
        self.scrollView = UIScrollView(frame: CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height))
        
        for i in 0..<numb {
            let frame = CGRect(x: rect.size.width * CGFloat(i), y: 0, width: rect.size.width, height: rect.size.height)
            self.cacheFrame[i] = frame
        }
        self.scrollView.backgroundColor = UIColor.white
        self.scrollView.isPagingEnabled = true
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        let wid = self.view.bounds.width * CGFloat(self.pageNumberOfChildController())
        self.scrollView.contentSize = CGSize(width: wid, height: rect.size.height)
        
        // 加载控制器
        self.addViewControllerAtIndex(index: self.selectIndex)
    }
    
    /// 有几个子控制器
    /// **子类必须实现
    /// - Returns: 子控制器个数
    public func pageNumberOfChildController() -> NSInteger {
        
        assert(false, "cannot pageNumberOfChildController")
        return 0
    }
    
    /// 对应的每个控制器
    /// ** 子类必须实现
    /// - Returns: 当前子控制器
    public func pageChildControllerOfCurrent(index: NSInteger) -> UIViewController {
        
        assert(false,"cannot pageChildControllerOfCurrent")
        return UIViewController()
    }
    
    /// 控件的尺寸
    /// ** 子类必须实现
    /// - Returns: 尺寸
    public func pageChildControllerOfRect() -> CGRect {
        
        assert(false, "cannot pageChildControllerOfRect")
        return CGRect.zero
    }
    
    /// 滚动停止时的选择
    ///
    /// - Returns: 选择的位置
    public func pageChildControllerScrollEnd(index: NSInteger) {
        // 子类需要可以覆盖
    }
    
    /// 滚动中的偏移
    ///
    /// - Parameter scrollOffset: 偏移的位置
    public func pageChildControllerScrolling(scrollOffset: CGFloat) {
        // 子类需要可以覆盖
    }
    
    /// 指定展示的视图位置
    /// 不可覆盖
    /// - Parameter index: 位置
    final func pageChildControllerCurrentWithIndex(index: NSInteger) {
        
        self.removeChildController(index: self.selectIndex)
        
        self.addViewControllerAtIndex(index: index)
        
        let rect = self.view.frame
        self.scrollView.setContentOffset(CGPoint(x:rect.width * CGFloat(index), y: 0), animated: false)
        
        self.selectIndex = index
    }
    
    /// 移除上个控制器
    private func removeChildController(index: NSInteger) {
        
        let controller = self.cacheController[index]
        controller?.removeFromParent()
        controller?.view.removeFromSuperview()
    }
    
    /// 加载viewcontroller
    private func addViewControllerAtIndex(index: NSInteger) {
        
        //如果控制器大于总个数
        if index >= self.pageNumberOfChildController() || index < 0 {
            return
        }
        
        //对应的控制器
        let subController: UIViewController!
        
        if self.cacheController[index] != nil {
            subController = self.cacheController[index]
        }else {
            subController = self.pageChildControllerOfCurrent(index: index)
            //添加到缓存
            self.cacheController[index] = subController
        }
        
        let frame = self.cacheFrame[index]
        subController.view.frame = frame!
        self.addChild(subController) //添加到视图上
        subController.didMove(toParent: self) //移动
        self.scrollView.addSubview(subController.view)
    }
}

extension ZPPageViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
        
        self.pageChildControllerScrolling(scrollOffset: offsetX)
        
        var page:Float
        if offsetX > self.selectOffsetx {
            page = ceilf(Float(offsetX / scrollView.bounds.width))
        }else {
            page = floorf(Float(offsetX / scrollView.bounds.width))
        }
        
        self.selectOffsetx = offsetX
        
        if self.selectPage != NSInteger(page) {

            //添加子控制器
            self.addViewControllerAtIndex(index: NSInteger(page))
            self.selectPage = NSInteger(page)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
        
        let index = offsetX / scrollView.bounds.width
        
        self.pageChildControllerScrollEnd(index: NSInteger(index))
        
        if self.selectIndex == NSInteger(index) {
            return
        }
        
        //移除上个控制器
        self.removeChildController(index: self.selectIndex)
        
        self.selectIndex = NSInteger(index)
    }
}
