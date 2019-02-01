//
//  ZPHNodeModel.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/1/30.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

@objcMembers

class ZPHNodeModel: NSObject {
    
    var nodeFade:String?//节点名字
    var types:[ZPHNodeTypeModel]?//节点内容
    
    init(dic:[String:Any]) {
        
        super.init()
        
        setValuesForKeys(dic)
        if (dic["types"] != nil) {
            var arr:[ZPHNodeTypeModel] = [ZPHNodeTypeModel]()
            let typeArr:[[String:Any]] = dic["types"] as! [[String : Any]]
            for type in typeArr {
                let typeModel = ZPHNodeTypeModel(dic: type)
                arr.append(typeModel)
            }
            types = arr
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

@objcMembers
class ZPHNodeTypeModel: NSObject {
    
    var uri:String?
    var name:String?
    
    init(dic:[String:Any]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {

    }
}
