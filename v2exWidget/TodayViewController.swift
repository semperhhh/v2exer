//
//  TodayViewController.swift
//  v2exWidget
//
//  Created by zhangpenghui on 2019/2/28.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let KWidth:Int = Int(UIScreen.main.bounds.size.width)
    let KHeight = 110
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.compact
        
        getUseTime()
    }
    
    //MARK:使用时间
    func getUseTime() {

        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: KWidth, height: KHeight))
        self.view.addSubview(backgroundView)

        let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: KWidth, height: 55))
        timeLabel.textAlignment = NSTextAlignment.center
        timeLabel.textColor = UIColor.black
        timeLabel.font = UIFont.systemFont(ofSize: 26)
        self.view.addSubview(timeLabel)
        
        let firstDateString = "20190221"
        let secondDate = Date()
        
        let dateforma = DateFormatter()
        dateforma.dateFormat = "yyyyMMdd"
        let firstDate = dateforma.date(from: firstDateString)
        
        let interval = secondDate.timeIntervalSince(firstDate!)
        
        let D_DAY = 60 * 60 * 24//一天
        
        timeLabel.text = "使用已经 \(Int(interval) / D_DAY) 天!!"
        
        let weekLabel = UILabel(frame: CGRect(x: 0, y: 55, width: KWidth, height: 55))
        weekLabel.textAlignment = NSTextAlignment.center
        weekLabel.textColor = UIColor.black
        weekLabel.font = UIFont.systemFont(ofSize: 18)
        self.view.addSubview(weekLabel)
        
        var weekString:String?
        let calendar = Calendar.current
        if let weekday = calendar.dateComponents([.weekday], from: Date()).weekday {
            
            print("weekday = \(weekday)")
            
            switch weekday {
            case 1:
                weekString = "距周五还有 5 天"
                break
            case 2:
                weekString = "距周五还有 4 天"
                break
            case 3:
                weekString = "距周五还有 3 天"
                break
            case 4:
                weekString = "距周五还有 2 天"
                break
            case 5:
                weekString = "距周五还有 1 天"
                break
            case 6:
                weekString = "今天是周五 !"
                break
            case 7:
                weekString = "距周五还有 6 天"
                break
            default:
                break
            }
            
            weekLabel.text = weekString
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
