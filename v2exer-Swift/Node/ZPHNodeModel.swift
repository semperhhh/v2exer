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
    var types:[String]?//节点内容
    
    init(dic:[String:Any]) {
        
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
