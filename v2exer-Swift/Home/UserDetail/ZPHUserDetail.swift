//
//  ZPHUserDetail.swift
//  v2exer-Swift
//
//  Created by 张鹏辉 on 2019/3/7.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

@objcMembers
class ZPHUserDetail: NSObject {

    var title:String?
    var post:String?//帖子名称
    var postUrl:String?//地址
    
    var cellHeight:CGFloat?
    
    init(dic:[String:String]) {
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
