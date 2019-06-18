//
//  ZPHEditCollectionViewCell.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/2/24.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHEditCollectionViewCell: UICollectionViewCell {
    
    /// 图片
    var selectImage:UIImage? {
        didSet {
            self.imgView.image = self.selectImage
        }
    }
    
    var imgView:UIImageView = {
        var imgview = UIImageView()
        imgview.image = UIImage(named: "addPhoto")
        return imgview
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
