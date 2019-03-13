//
//  ZPHUserDetailCell.swift
//  v2exer-Swift
//
//  Created by 张鹏辉 on 2019/3/7.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHUserDetailCell: UITableViewCell {
    
    /// 模型
    var model:ZPHUserDetail? {
        didSet {
            
            var cellH:CGFloat = 0
            
            if let titleStr = model?.title {
                
                let titleAttri:NSMutableAttributedString = NSMutableAttributedString(string: titleStr, attributes:[NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)])
                let titleSize = titleAttri.boundingRect(with: CGSize(width: self.bounds.size.width, height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
                self.titleLabel.attributedText = titleAttri
                self.titleLabel.snp.updateConstraints { (make) in
                    make.height.equalTo(titleSize.height + 30)
                }
                cellH += titleSize.size.height + 30
            }
            
            if let postStr = model?.post {
                
                let postAttri = NSMutableAttributedString(string: postStr, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)])
                let postSize = postAttri.boundingRect(with: CGSize(width: self.bounds.size.width, height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
                self.postLabel.attributedText = postAttri
                self.postLabel.snp.updateConstraints { (make) in
                    make.height.equalTo(postSize.height + 20)
                }
                cellH += postSize.size.height + 20
            }
            
            model?.cellHeight = cellH + 10
        }
    }
    
    var titleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = UIColor(red: 238.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        return label
    }()
    
    var postLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = UIColor.white
        return label;
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(contentView).offset(8)
            make.right.equalTo(contentView).offset(-5)
            make.height.equalTo(0)
        }
        
        contentView.addSubview(postLabel)
        postLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView).offset(5)
            make.right.equalTo(contentView).offset(-5)
            make.height.equalTo(0)
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
