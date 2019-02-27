//
//  ZPHHomeTableViewCell.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2018/12/20.
//  Copyright © 2018 zph. All rights reserved.
//

import UIKit
import Kingfisher

class ZPHHomeTableViewCell: UITableViewCell {
    
    //背景
    private var backView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12
        return view
    }()
    
    //左边背景
    private var leftBackView:UIView = {
        let view = UIView()
        view.backgroundColor = tabColorGreen
        return view
    }()
    
    //头像
    private var headImgView:UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 18
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    //标题
    private var titleLab:UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 2
        return lab
    }()
    
    //最后回复
    private var lastReplyLab:UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor(red: 150.0/255.0, green: 150.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        lab.font = UIFont.systemFont(ofSize: 13)
        return lab
    }()
    
    //最后回复:天
    private var lastReplyDay:UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.white
        lab.font = UIFont.systemFont(ofSize: 13)
        return lab
    }()
    
    //最后回复:时间
    private var lastReplyTime:UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.white
        lab.font = UIFont.systemFont(ofSize: 13)
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
    
    //模型
    var homeModel:ZPHHome? {
        
        didSet {
            
            titleLab.text = homeModel?.title
            
            if homeModel?.avatar == nil {
                
                if let avatar = homeModel?.member?.avatar_normal {
                    
                    let url = URL(string: "http:" + avatar)
                    headImgView.kf.setImage(with: url)
                }
            }else {
                
                let url = URL(string: "http:" + (homeModel?.avatar)!)
                headImgView.kf.setImage(with: url)
            }
            
            if let lastreply = homeModel?.last_reply_by {
                
                lastReplyLab.text = "最后回复 " + lastreply
            }
            
            if let lastTouched = homeModel?.last_touch {
                
                let array1 = lastTouched.components(separatedBy: "日")
                
                lastReplyDay.text = array1.first
                lastReplyTime.text = array1.last
            }
            
            if let nodeTitle = homeModel?.nodeTitle {
                
                nodeTitleBtn.isHidden = false
                nodeTitleBtn.setTitle(nodeTitle, for: UIControl.State.normal)
                
            }else if let nodeTitle = homeModel?.node?.title {
                
                nodeTitleBtn.isHidden = false
                nodeTitleBtn.setTitle(nodeTitle, for: UIControl.State.normal)
                
            }else {
                nodeTitleBtn.isHidden = true
            }
        }
    }
    
    //按钮回调
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
        }
        
        contentView.addSubview(leftBackView)
        leftBackView.frame = CGRect(x: 10, y: 5, width: 80, height: 120)
        let maskPath = UIBezierPath(roundedRect: leftBackView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.topLeft.rawValue), cornerRadii: CGSize(width: 12, height: 12))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = leftBackView.bounds
        maskLayer.path = maskPath.cgPath
        leftBackView.layer.mask = maskLayer
        
        leftBackView.addSubview(headImgView)
        headImgView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.centerX.equalTo(self.leftBackView)
            make.top.equalTo(self.leftBackView).offset(20)
        }
        
        leftBackView.addSubview(lastReplyDay)
        lastReplyDay.snp.makeConstraints { (make) in
            make.centerX.equalTo(headImgView)
            make.top.equalTo(headImgView.snp.bottom).offset(20)
        }
        
        leftBackView.addSubview(lastReplyTime)
        lastReplyTime.snp.makeConstraints { (make) in
            make.centerX.equalTo(headImgView)
            make.top.equalTo(lastReplyDay.snp.bottom).offset(5)
        }
        
        backView.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(leftBackView).offset(5)
            make.right.equalTo(backView).offset(-10)
            make.left.equalTo(leftBackView.snp.right).offset(5)
        }
        
        backView.addSubview(nodeTitleBtn)
        nodeTitleBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(backView.snp.bottom).offset(-10)
            make.left.equalTo(titleLab)
            make.height.equalTo(18)
        }
        
        backView.addSubview(lastReplyLab)
        lastReplyLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(nodeTitleBtn.snp.top).offset(-8)
            make.left.equalTo(titleLab)
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
