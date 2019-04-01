//
//  ZPHHomeTimeCollectionViewCell.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/4/1.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHHomeTimeCollectionViewCell: UICollectionViewCell {
    
    private var timeLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.contentView.addSubview(timeLabel)
        self.timeLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
