//
//  ZPHUpinstallTableViewCell.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/2/28.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHUpinstallTableViewCell: UITableViewCell {
    
    var backview:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        view.layer.cornerRadius = 4
        return view
    }()
    
    var contentLabel:UILabel = {
        let lab = UILabel()
        lab.textAlignment = NSTextAlignment.center
        return lab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.white
        
        self.contentView.addSubview(backview)
        backview.snp.makeConstraints { (make) in
            make.top.left.equalTo(5)
            make.bottom.right.equalTo(-5)
        }
        
        backview.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(backview)
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
