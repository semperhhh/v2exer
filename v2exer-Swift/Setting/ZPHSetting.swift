//
//  ZPHSetting.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/1/13.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

@objcMembers
class ZPHSetting: NSObject {
    
    var avatar_large:String?//头像
    var avatar_mini:String?
    var avatar_normal:String?
    var bio:String?
    var btc:String?
    var created:Int = 0//创建时间戳
    var github:String?//github地址
    var Id:Int = 0//数字id
    var location:String?//地址
    var psn:String?
    var status:String?//状态
    var tagline:String?
    var twitter:String?//twitter
    var url:String?//个人界面
    var username:String?//用户名
    var website:String?
    
    init(dic:[String:Any]) {
        
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
