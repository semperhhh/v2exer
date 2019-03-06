//
//  ZPHEditPickerView.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/2/27.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHEditPickerView: UIView {
    
    //节点选择
    var pickerView:UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    var nodesArray = [[String:String]]() {
        
        didSet {
            
            self.pickerView.reloadAllComponents()
            let dic = nodesArray.first!
            self.nodeSelect = dic["name"]
            self.valueSelect = dic["value"]
        }
    }
    
    var topView:UIView = {
        let view = UIView()
        return view
    }()
    
    //确定
    var determineButton:UIButton = {
        let button = UIButton()
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    ///取消
    var cancelButton:UIButton = {
        let button = UIButton()
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    //确定回调
    var determineBlock:((_ nodeString:String, _ value:String) -> Void)?
    
    //选中的节点
    var nodeSelect:String?
    var valueSelect:String?

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        
        self.addSubview(pickerView)
        pickerView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(210)
        }
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(pickerView.snp.top)
        }
        
        topView.addSubview(determineButton)
        determineButton.addTarget(self, action: #selector(determineButtonAction), for: .touchUpInside)
        determineButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(topView)
            make.width.equalTo(60)
        }
        
        topView.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        cancelButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(topView)
            make.width.equalTo(60)
        }
    }
    
    func dismiss() {
        
        UIView.animate(withDuration: 0.5) {
            self.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 250)
        }
    }
    
    func show() {
        
        UIView.animate(withDuration: 0.5) {
            self.frame = CGRect(x: 0, y: kScreenHeight - 250, width: kScreenWidth, height: 250)
        }
    }
    
    @objc func determineButtonAction() {
        
        dismiss()
        
        //回调
        if determineBlock != nil {
            determineBlock!(self.nodeSelect!,self.valueSelect!)
        }
    }
    
    @objc func cancelButtonAction() {
        
        dismiss()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ZPHEditPickerView:UIPickerViewDataSource,UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.nodesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let dic = self.nodesArray[row]
        
        let view = UIView()
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.text = dic["name"]
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        return view
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let dic = self.nodesArray[row]
        
        self.nodeSelect = dic["name"]
        self.valueSelect = dic["value"]
    }
}
