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
    
    //节点名称
    private var nodeTitleBtn:UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.titleLabel?.textAlignment = NSTextAlignment.center
        btn.setTitleColor(UIColor(red: 190.0/255.0, green: 190.0/255.0, blue: 190.0/255.0, alpha: 1.0), for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        btn.layer.cornerRadius = 2.5
        return btn
    }()
    
    //头像
    private var headImgButton:UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 12
        btn.layer.masksToBounds = true
        return btn
    }()
    
    //标题
    private var titleLab:UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lab.numberOfLines = 0
        lab.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
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
    
    /// 头像点击block
    var headImageBlock : ((_ userHref: String)->Void)?
    
    /// 节点点击block
    var nodeTitleBlock:((_ url: String,_ name: String) -> Void)?
    
    //模型
    var homeModel:ZPHHome? {
        
        didSet {
            
            self.titleLab.text = homeModel?.title
            
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
            let titleHeight = homeModel?.title?.boundingOfheight(attributes: attributes, fixedWidth: kScreenWidth - 40)
            self.homeModel?.cellHeight = 100 + titleHeight!
            
            if homeModel?.avatar == nil {
                
                if let avatar = homeModel?.member?.avatar_normal {
                    
                    let url = URL(string: "http:" + avatar)
                    headImgButton.kf.setBackgroundImage(with: url, for: .normal, placeholder: UIImage(named: "head_placeholder"))
                }
            }else {
                
                let url = URL(string: "http:" + (homeModel?.avatar)!)
                headImgButton.kf.setBackgroundImage(with: url, for: .normal)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
        }

        nodeTitleBtn.addTarget(self, action: #selector(nodeTitleBtnAction), for: .touchUpInside)
        backView.addSubview(nodeTitleBtn)
        nodeTitleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(backView).offset(10)
            make.right.equalTo(backView).offset(-10)
            make.height.equalTo(26)
        }
        
        headImgButton.addTarget(self, action: #selector(headImgButtonAction), for: .touchUpInside)
        backView.addSubview(headImgButton)
        headImgButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.left.equalTo(self.backView).offset(10)
            make.centerY.equalTo(self.nodeTitleBtn)
        }
        
        backView.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.nodeTitleBtn.snp.bottom).offset(10)
            make.right.equalTo(backView).offset(-10)
            make.left.equalTo(self.headImgButton)
        }

        backView.addSubview(lastReplyLab)
        lastReplyLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(10)
            make.left.equalTo(titleLab)
        }
        
        backView.addSubview(lastReplyTime)
        lastReplyTime.snp.makeConstraints { (make) in
            make.centerY.equalTo(lastReplyLab)
            make.left.equalTo(lastReplyLab.snp.right).offset(10)
        }
    }
    
    //MARK:头像点击回调
    @objc func headImgButtonAction() {
    
        if (self.headImageBlock != nil) {
            self.headImageBlock!(homeModel?.member?.url ?? homeModel?.userHref ?? "没有找到用户地址")
        }
    }
    
    //节点点击回调
    @objc func nodeTitleBtnAction() {
        
        if self.nodeTitleBlock != nil {
            self.nodeTitleBlock!(homeModel?.node?.url ?? "没有找到节点地址",homeModel?.node?.title ?? "没有找到节点名字")
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
