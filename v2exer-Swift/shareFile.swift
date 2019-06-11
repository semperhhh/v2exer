//
//  shareFile.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2018/12/22.
//  Copyright © 2018 zph. All rights reserved.
//

import UIKit
@_exported import Alamofire
@_exported import DGElasticPullToRefresh
@_exported import NVActivityIndicatorView
@_exported import Ji

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

//适配iphonex
let StausbarHeight = UIApplication.shared.statusBarFrame.size.height
let iPhoneX = StausbarHeight > 20 ? true : false

//底部安全区域远离高度
let kBottomSafeHeight = StausbarHeight > 20 ? 34 : 0
//导航栏
let kTopBarHeight = StausbarHeight > 20 ? 88 : 64
//标签栏
let kTabBarHeight = StausbarHeight > 20 ? 83 : 49

let tabColorGreen = UIColor(red: 27.0/255.0, green: 146.0/255.0, blue: 52.0/255.0, alpha: 1.0)
let appColorBlack = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)

//用户代理，使用这个切换是获取 m站点 还是www站数据
let USER_AGENT = "Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.3 (KHTML, like Gecko) Version/8.0 Mobile/12A4345d Safari/600.1.4";
let MOBILE_CLIENT_HEADERS = ["user-agent":USER_AGENT]

//个人信息网址
let SETTINGURL = "https://www.v2ex.com/api/members/show.json"
let V2EXURL = "https://www.v2ex.com"

//用户id 判断是否登录使用 227789
var USERID:Int = 0
//用户名 判断是否登录使用
var USERNAME:String?
//Once 登出使用
var ONCE:String?

// MARK: - 随机颜色
extension UIColor {
    
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

// MARK: - 计算文本高度
extension String {
    
    func boundingOfheight(attributes: [NSAttributedString.Key:Any], fixedWidth: CGFloat) -> CGFloat {
        
        guard self.count > 0 && fixedWidth > 0 else {
            return 0
        }
        
        let size = CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))
        let rect = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size.height
    }
}

// MARK: - 渐变色图片
extension UIImage {
    
    
}
