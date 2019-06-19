//
//  ZPHEditCollectionViewCell.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/2/24.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHEditCollectionViewCell: UICollectionViewCell {
    
    /// 图片赋值
    var selectImage:UIImage? {
        didSet {
            
            self.imgView.image = selectImage ?? UIImage(named: "addPhoto")
            
            if selectImage != nil {
                self.cancelButton.isHidden = false
            }else {
                self.cancelButton.isHidden = true
            }
            
        }
    }
    
    /// 图片
    var imgView:UIImageView = {
        var imgview = UIImageView()
        imgview.image = UIImage(named: "addPhoto")
        return imgview
    }()
    
    /// 删除按钮
    var cancelButton:UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "editCancel"), for: .normal)
        return button
    }()
    
    /// 删除回调
    var cancelButtonBlock:(() -> ())!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.contentView.addSubview(self.imgView)
        self.imgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        self.contentView.addSubview(self.cancelButton)
        self.cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        self.cancelButton.isHidden = true
        self.cancelButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
    }
    
    @objc private func cancelButtonClick() {
        
        if self.cancelButtonBlock != nil {
            self.cancelButtonBlock()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
