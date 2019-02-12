//
//  ZPHNodeModel.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/1/30.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

@objcMembers

class ZPHNodeModel: NSObject,NSCoding {
    
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
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nodeFade, forKey: "nodeFade")
        aCoder.encode(types, forKey: "types")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        nodeFade = aDecoder.decodeObject(forKey: "nodeFade") as! String?
        types = aDecoder.decodeObject(forKey: "types") as! Array?
    }
}

@objcMembers
class ZPHNodeTypeModel: NSObject,NSCoding {
    
    var uri:String?
    var name:String?
    
    init(dic:[String:Any]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uri, forKey: "uri")
        aCoder.encode(name, forKey: "name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        uri = aDecoder.decodeObject(forKey: "uri") as! String?
        name = aDecoder.decodeObject(forKey: "name") as! String?
    }
}
