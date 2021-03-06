//
//  ZPHHome.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2018/12/20.
//  Copyright © 2018 zph. All rights reserved.
//

import UIKit

@objcMembers
class ZPHHome: NSObject {
    
    ///内容
    var content:String?
    ///标题
    var title:String?
    ///最后更新于
    var last_modified:Int = 0
    ///最后回复于
    var last_reply_by:String?
    
    var member:ZPHHomeMember?
    ///节点信息
    var node:ZPHHomeNode?
    ///节点名称
    var nodeTitle:String?
    var url : String?//网址
//    @objc var Id : String = ""
    var last_touch:String?//最后回复时间
    var avatar:String?//头像
    
    var userHref:String?//创建用户地址
    
    /// 行高
    var cellHeight: CGFloat = 0
    
    init(dic:[String:Any]) {
        
        super.init()
        
        setValuesForKeys(dic)
        
        if let memberDict = dic["member"] as? [String : Any] {
            member = ZPHHomeMember.init(dic: memberDict)
        }
        
        if let nodeDict = dic["node"] as? [String : Any] {
            node = ZPHHomeNode.init(dic: nodeDict)
        }
        
        if let touched = dic["last_touched"] as? Int {
            
            let time:TimeInterval = TimeInterval(touched)
            let date = NSDate(timeIntervalSince1970: time)
            let dfmattter = DateFormatter()
            dfmattter.dateFormat = "MM月dd日 HH:mm:ss"
            last_touch = dfmattter.string(from: date as Date)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}


class ZPHHomeMember: NSObject {
 
    @objc var avatar_normal:String?//正常头像
    @objc var username:String?//用户名
    @objc var url:String?//用户网址
    
    init(dic:[String:Any]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    
    }
}

class ZPHHomeNode: NSObject {
    
    @objc var title:String?//节点
    @objc var url:String?//节点地址
    init(dic:[String:Any]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
