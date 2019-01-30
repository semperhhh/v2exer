//
//  ZPHSettingTableViewCell.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/1/13.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHSettingTableViewCell: UITableViewCell {
    
    internal var nameTitle:String? {
        didSet {
            nameLabel.text = nameTitle
        }
    }
    
    private var nameLabel:UILabel = {
        var label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.white
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(contentView)
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
