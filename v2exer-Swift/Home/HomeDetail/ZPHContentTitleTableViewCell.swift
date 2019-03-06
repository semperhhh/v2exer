//
//  ZPHContentTitleTableViewCell.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/2/1.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHContentTitleTableViewCell: UITableViewCell {
    
    //背景
    var backView:UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 240.0/255.0, green: 242.0/255.0, blue: 252.0/255.0, alpha: 1.0)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    //标题
    var headLabel:UILabel = {
        var lab = UILabel()
        lab.numberOfLines = 0
        return lab
    }()
    //内容
    var contentLabel:UILabel = {
        var lab = UILabel()
        lab.numberOfLines = 0
        return lab
    }()
    
    var cellHeight:CGFloat?
    
    var contentDic:[String:Any] = [String:Any]() {
        didSet {
            
            let headAttr = contentDic["head"] as? NSMutableAttributedString
            headAttr?.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 28, weight: .heavy),.foregroundColor:UIColor.black], range: NSRange(location: 0, length: (headAttr?.length ?? 0)))
            let contentAttr = contentDic["content"] as? NSMutableAttributedString
            contentAttr?.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: (contentAttr?.length ?? 0)))
            
            self.headLabel.attributedText = headAttr
            self.contentLabel.attributedText = contentAttr
            
            if let boundingHead = headAttr?.boundingRect(with: CGSize(width: kScreenWidth - 20, height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil) {
                
                cellHeight = boundingHead.height + 20
            }
            
            if let boundingRect = contentAttr?.boundingRect(with: CGSize(width: kScreenWidth - 20, height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil) {
                
                cellHeight = boundingRect.height + 20
            }
            
//            print("cellHeight = \(String(describing: cellHeight))")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.contentView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(5)
            make.left.equalTo(self.contentView).offset(8)
            make.right.equalTo(self.contentView).offset(-8)
            make.bottom.equalTo(self.contentView).offset(-5).priority(.low)
        }
        
        backView.addSubview(headLabel)
        headLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(backView).offset(10)
            make.right.equalTo(backView).offset(-10)
        }

        backView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headLabel.snp_bottomMargin)
            make.left.equalTo(backView).offset(10)
            make.right.equalTo(backView).offset(-10)
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
