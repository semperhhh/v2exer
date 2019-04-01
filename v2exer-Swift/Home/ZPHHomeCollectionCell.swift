//
//  ZPHHomeCollectionCell.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/3/31.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHHomeCollectionCell: UICollectionViewCell {
    
    var model:ZPHHome? {
        
        didSet {
            
            self.titleLab.text = self.model?.title
            
            if let nodeTitle = model?.nodeTitle {
                
                nodeTitleBtn.isHidden = false
                nodeTitleBtn.setTitle(nodeTitle, for: UIControl.State.normal)
                
            }else if let nodeTitle = model?.node?.title {
                
                nodeTitleBtn.isHidden = false
                nodeTitleBtn.setTitle(nodeTitle, for: UIControl.State.normal)
                
            }else {
                nodeTitleBtn.isHidden = true
            }
        }
    }
    
    //背景
    private var backView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    //标题
    private var titleLab:UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 2
        return lab
    }()
    
    //节点名称
    private var nodeTitleBtn:UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.titleLabel?.textAlignment = NSTextAlignment.center
        btn.backgroundColor = UIColor(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        btn.layer.cornerRadius = 2.5
        return btn
    }()
    
    /// 节点点击block
    var nodeTitleBlock:((_ url: String,_ name: String) -> Void)?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.contentView.addSubview(self.backView)
        self.backView.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
            make.right.bottom.equalTo(-10)
        }
        
        self.backView.addSubview(self.titleLab)
        self.titleLab.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.backView).offset(10)
            make.right.equalTo(self.backView).offset(-10)
            make.height.equalTo(50)
        }
        
        nodeTitleBtn.addTarget(self, action: #selector(nodeTitleBtnAction), for: .touchUpInside)
        self.backView.addSubview(self.nodeTitleBtn)
        self.nodeTitleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(10)
            make.left.equalTo(self.titleLab)
            make.width.equalTo(120)
            make.height.equalTo(24)
        }
    }
    
    //节点点击回调
    @objc func nodeTitleBtnAction() {
        
        if self.nodeTitleBlock != nil {
            self.nodeTitleBlock!(model?.node?.url ?? "没有找到节点地址",model?.node?.title ?? "没有找到节点名字")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
