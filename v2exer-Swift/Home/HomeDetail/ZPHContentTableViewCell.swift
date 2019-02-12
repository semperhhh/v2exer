//
//  ZPHContentTableViewCell.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/2/1.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit
import Kingfisher

class ZPHContentTableViewCell: UITableViewCell {
    
    var model:ZPHContentDetailModel? {
        didSet {
            let url = URL(string: "http:" + (model?.img ?? ""))
            self.imgView.kf.setImage(with: url)
            
            let replyAttr = NSMutableAttributedString.init(string: (model?.reply ?? ""), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)])
            
            self.replyLabel.attributedText = replyAttr
    
            let boundingReply = replyAttr.boundingRect(with: CGSize(width: kScreenWidth - 44 - 50, height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)

            print("boundingReply = \(boundingReply.height)")
            
            if boundingReply.height + 30 > 44 {
                
                model?.cellHeight = boundingReply.height + 30 + 20
            }else {
                model?.cellHeight = 44 + 30
            }
            
            self.timeLabel.text = model?.time
        }
    }
    
    var imgView:UIImageView = {
        var imgView = UIImageView()
        return imgView
    }()
    
    var replyLabel:UILabel = {
        var lab = UILabel()
        lab.numberOfLines = 0
        return lab
    }()
    
    var timeLabel:UILabel = {
        var lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        lab.textColor = UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.contentView).offset(10)
            make.size.equalTo(CGSize.init(width: 44, height: 44))
        }
        
        self.contentView.addSubview(replyLabel)
        replyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imgView)
            make.left.equalTo(imgView.snp.rightMargin).offset(20)
            make.right.equalTo(self.contentView).offset(-20)
        }
        
        self.contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(replyLabel.snp.bottom).offset(10)
            make.left.right.equalTo(replyLabel)
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
