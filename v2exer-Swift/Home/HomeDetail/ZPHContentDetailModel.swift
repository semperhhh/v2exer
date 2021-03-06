//
//  ZPHContentDetailModel.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/2/2.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

@objcMembers
class ZPHContentDetailModel: NSObject {

    var time:String?
    var reply:String?
    var img:String?
    var userName:String?//用户名
    var userHref:String?//地址
    
    var cellHeight:CGFloat?
    
    init(dic:[String:Any]) {
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
