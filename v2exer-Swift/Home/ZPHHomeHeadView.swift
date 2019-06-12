//
//  ZPHHomeHeadView.swift
//  v2exer-Swift
//
//  Created by zph on 2019/6/11.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHHomeHeadView: UIView {
    
    /// 点击回调
    var headViewActionBlock:((String?) -> ())!
    
    /// 数据
    var model: ZPHHome? {
        
        didSet {
            self.titleLabel.text = model?.title
            self.nodeLabel.text = "来自节点: \(model?.node?.title ?? "")"
        }
    }
    
    /// 最热
    private var hotLabel: UILabel = {
        let lab = UILabel()
        lab.text = "当前最热话题"
        lab.textColor = UIColor.white
        lab.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return lab
    }()

    /// 标题
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = appColorBlack
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    /// 节点
    private var nodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [tabColorGreen.cgColor, UIColor.yellow.cgColor]
        gradient.locations = [0, 1]
        gradient.frame = self.frame
        self.layer.insertSublayer(gradient, at: 0)
        
        self.addSubview(self.hotLabel)
        self.hotLabel.snp_makeConstraints { (make) in
            make.top.left.equalTo(self).offset(20)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.hotLabel.snp_bottom).offset(10)
            make.left.equalTo(self.hotLabel)
            make.right.equalTo(self).offset(-20)
        }
        
        self.addSubview(self.nodeLabel)
        self.nodeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.bottom.equalTo(self).offset(-20)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(headViewTap))
        self.addGestureRecognizer(tap)
    }
    
    @objc func headViewTap() {
        
        if self.headViewActionBlock != nil {
            self.headViewActionBlock(self.model?.url)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
