//
//  ZPHNodeCollectionCell.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/6/7.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHNodeCollectionCell: UICollectionViewCell {
    
    var model : ZPHNodeTypeModel? {
        
        didSet {
            
            if let name = model?.name {
                self.headLabel.text = String(name[name.startIndex])
                self.contentLabel.text = name
            }
        }
    }

    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.headLabel.layer.cornerRadius = 6
        self.headLabel.layer.masksToBounds = true
        self.headLabel.backgroundColor = UIColor.randomColor
    }

}
