//
//  ZPHUserDetailPart.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/3/24.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

@objcMembers
class ZPHUserDetailPart: NSObject {

    var content:String?
    var contentHref:String?
    
    var cellHeight:CGFloat = 0
    
    init(dic:[String:String]) {
        
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
