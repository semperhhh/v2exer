//
//  TodayViewController.swift
//  v2exWidget
//
//  Created by zhangpenghui on 2019/2/28.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit
import NotificationCenter
import SnapKit

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let KWidth:Int = Int(UIScreen.main.bounds.size.width)
    let KHeight = 110

    var backgroundView1:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()

    var timeNameLabel:UILabel = {
        let label = UILabel()
        label.text = "使用已经"
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: 300))
        return label
    }()
    
    //117 218 86
    var backgroundView2:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var weekNameLabel:UILabel = {
        let label = UILabel()
        label.text = "距周五还有"
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: 300))
        return label
    }()
    
    var onceTime:String?
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        //默认渲染
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.compact
        
        let shared = UserDefaults(suiteName: "group.v2exer")
        onceTime = shared?.value(forKey: "onceTime") as? String
        
        getUseTime()
    }
    
    //MARK:使用时间
    func getUseTime() {
        
        self.view.addSubview(backgroundView1)
        backgroundView1.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(55)
        }
        
        backgroundView1.addSubview(timeNameLabel)
        timeNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundView1).offset(15)
            make.centerY.equalTo(backgroundView1)
        }
        
        self.view.addSubview(backgroundView2)
        backgroundView2.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self.view)
            make.height.equalTo(55)
        }
        
        backgroundView2.addSubview(weekNameLabel)
        weekNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeNameLabel)
            make.centerY.equalTo(backgroundView2)
        }

        let timeLabel = UILabel()
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 600))
        timeLabel.backgroundColor = UIColor(red: 120.0/255.0, green: 118.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        timeLabel.layer.cornerRadius = 4
        timeLabel.layer.masksToBounds = true
        
        let secondDate = Date()
        
        let dateforma = DateFormatter()
        dateforma.dateFormat = "yyyyMMdd"
        let firstDate = dateforma.date(from: onceTime ?? "20190221")
        
        let interval = secondDate.timeIntervalSince(firstDate!)
        
        let D_DAY = 60 * 60 * 24//一天
        
        timeLabel.text = "  \(Int(interval) / D_DAY) 天!!  "
        
        let weekLabel = UILabel()
        weekLabel.textColor = UIColor.white
        weekLabel.backgroundColor = UIColor(red: 117.0/255.0, green: 218.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        weekLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 600))
        weekLabel.layer.cornerRadius = 4
        weekLabel.layer.masksToBounds = true
        
        var weekString:String?
        let calendar = Calendar.current
        if let weekday = calendar.dateComponents([.weekday], from: Date()).weekday {
            
            print("weekday = \(weekday)")
            
            switch weekday {
            case 1:
                weekString = "  5 天  "
                break
            case 2:
                weekString = "  4 天  "
                break
            case 3:
                weekString = "  3 天  "
                break
            case 4:
                weekString = "  2 天  "
                break
            case 5:
                weekString = "  1 天  "
                break
            case 6:
                weekString = "  今天是周五 !  "
                break
            case 7:
                weekString = "  6 天  "
                break
            default:
                break
            }
            
            weekLabel.text = weekString
        }
        
        backgroundView1.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backgroundView1)
            make.right.equalTo(backgroundView1).offset(-15)
            make.height.equalTo(20)
        }
        
        backgroundView2.addSubview(weekLabel)
        weekLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backgroundView2)
            make.right.equalTo(timeLabel)
            make.height.equalTo(20)
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
