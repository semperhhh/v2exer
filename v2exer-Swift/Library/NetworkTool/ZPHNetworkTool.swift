//
//  ZPHNetworkTool.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/2/26.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHNetworkTool: NSObject {

    class func networkRequest(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, responseBlock: @escaping (String) -> ()) {
        
        Alamofire.request(url, method: method, parameters: parameters).responseString { (response) in
            
            if let reString = response.result.value {
                
                responseBlock(reString)
            }
        }
    }
}
