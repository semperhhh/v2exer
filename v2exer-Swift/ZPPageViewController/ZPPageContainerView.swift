//
//  ZPPageContainerView.swift
//  pageController
//
//  Created by zph on 2019/6/10.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPPageContainerView: UIView {

    /// 数组
    var titleArray: [Any]!
    /// 样式
    var modality: ZPPageContainerModality!
    
    /// 底部的选择器
    private var lineView: UIView!
    /// 选中的位置
    private var selectLabel: UILabel!
    /// 存放label的数组
    private var labelArray = [UILabel]()
    /// 线的初始位置
    private var linePoint: CGPoint!
    
    var topViewAction : ((NSInteger) -> ())!
    
    init(frame: CGRect, titleArray: [Any], modality: ZPPageContainerModality) {

        super.init(frame: frame)
        self.titleArray = titleArray
        self.modality = modality
        
        if self.modality.isHaveLineContainer {
            self.lineView = UIView()
            self.lineView.backgroundColor = UIColor.green
            self.addSubview(self.lineView)
        }
        
        self.viewAddUI()
    }
    
    private func viewAddUI() {
        
        for i in 0..<self.titleArray.count {
            let labelwidth = self.bounds.width / CGFloat(self.titleArray.count)
            let labelx = CGFloat(i) * labelwidth
            let labely = 0
            let labelheight = self.bounds.height
            let label = UILabel(frame: CGRect(x: labelx, y: CGFloat(labely), width: labelwidth, height: labelheight))
            label.text = self.titleArray[i] as? String
            label.textColor = self.modality.normalColor
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.tag = 1000 + i
            label.isUserInteractionEnabled = true
            
            //点击事件
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelAction))
            label.addGestureRecognizer(tap)
            self.addSubview(label)
            self.labelArray.append(label)
            
            if i == 0 {
                self.selectLabel = label
                self.selectLabel.textColor = self.modality.selectColor
                
                if self.modality.isHaveLineContainer {
                    self.lineView.frame = CGRect(x: self.selectLabel.frame.midX - 20, y: self.selectLabel.frame.maxY - 2, width: 40, height: 2)
                    self.linePoint = CGPoint(x: self.lineView.center.x, y: self.lineView.center.y)
                }
            }
        }
    }
    
    @objc private func labelAction(tap: UITapGestureRecognizer) {
        
        let sender = tap.view as! UILabel
        
        if self.selectLabel == sender {
            return
        }
        
        self.selectLabel.textColor = self.modality.normalColor
        self.selectLabel = sender
        self.selectLabel.textColor = self.modality.selectColor
        
        //TODO: 回调
        if (self.topViewAction != nil) {
            self.topViewAction(sender.tag - 1000)
        }
        
        if self.modality.isHaveLineContainer {
            
            UIView.animate(withDuration: 0.3) {
                self.lineView.frame = CGRect(x: self.selectLabel.frame.midX - 20, y: self.selectLabel.frame.maxY - 2, width: 40, height: 2)
            }
        }
    }
    
    /// 选择的索引
    ///
    /// - Parameter index: 索引
    func modalitySelect(index: NSInteger) {
        
        self.selectLabel.textColor = self.modality.normalColor
        
        for label:UILabel in self.labelArray {
            if label.tag - 1000 == index {
                self.selectLabel = label
            }
        }
    }
    
    /// 滑动过程的联动
    ///
    /// - Parameter offset: 偏移量
    func modalityScroll(offset: CGFloat) {
        
        let offsetx = offset / CGFloat(self.titleArray.count)
        self.lineView.center = CGPoint(x: self.linePoint.x + offsetx, y: self.linePoint.y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ZPPageContainerModality: NSObject {

    ///未选中的颜色,默认灰色
    var normalColor: UIColor = UIColor.gray
    ///选中的颜色,默认绿色
    var selectColor: UIColor = UIColor.green
    ///线条选择器尺寸,默认 40 2
    var lineContainerSize: CGSize?
    ///是否展示线条选择器,默认false
    var isHaveLineContainer: Bool = false
}
