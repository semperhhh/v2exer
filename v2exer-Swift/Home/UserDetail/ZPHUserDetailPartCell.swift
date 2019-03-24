//
//  ZPHUserDetailPartCell.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/3/23.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHUserDetailPartCell: UITableViewCell {
    
    var model:ZPHUserDetailPart? {
        didSet {
            
            if let content = model?.content {
                
                let attri = NSAttributedString(string: content, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)])
                let contentRect = attri.boundingRect(with: CGSize(width: self.bounds.size.width, height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
                self.contentLab.attributedText = attri
                model?.cellHeight = contentRect.size.height + 40
            }
        }
    }
    
    private var contentLab:UILabel = {
        var lab = UILabel()
        lab.numberOfLines = 0
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.contentLab)
        self.contentLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(5)
            make.right.equalTo(self.contentView).offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
