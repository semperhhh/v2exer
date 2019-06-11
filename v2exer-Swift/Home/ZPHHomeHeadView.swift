//
//  ZPHHomeHeadView.swift
//  v2exer-Swift
//
//  Created by zph on 2019/6/11.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHHomeHeadView: UIView {
    
    /// 数据
    var model: ZPHHome? {
        
        didSet {
            self.titleLabel.text = model?.title
            self.nodeLabel.text = model?.node?.title
        }
    }
    
    /// 标题
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = appColorBlack
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    /// 节点
    var nodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 150.0/255.0, green: 150.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        return label
    }()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.randomColor
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.top.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
        
        self.addSubview(self.nodeLabel)
        self.nodeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp_bottom).offset(24)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
