//
//  ZPHEditViewController.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/2/21.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHEditViewController: UIViewController {
    
    var backButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.white
        btn.setTitle("删除", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    var releseButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = tabColorGreen
        btn.setTitle("发布", for: .normal)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    //标题
    var headlineTextfield:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "请输入标题"
        textfield.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        textfield.autocapitalizationType = UITextAutocapitalizationType.none
        textfield.autocorrectionType = UITextAutocorrectionType.no
        return textfield
    }()      
    
    //内容
    var contentTextView:UITextView = {
        let textview = UITextView()
        textview.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        textview.font = UIFont.systemFont(ofSize: 16)
        textview.autocapitalizationType = UITextAutocapitalizationType.none
        textview.autocorrectionType = UITextAutocorrectionType.no
        return textview
    }()
    
    //图片
    var pictureCollectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let pictWidth = (kScreenWidth - 40) / 3
        flowLayout.itemSize = CGSize(width: pictWidth - 3, height: pictWidth - 3)
        flowLayout.minimumInteritemSpacing = 3
        flowLayout.minimumLineSpacing = 3
        let collectionview = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionview.backgroundColor = UIColor.white
        return collectionview
    }()
    
    //图片数组
    var collectionArray:[Any] = ["1"]
    
    //节点
    var pickerButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        button.setTitle("节点选择", for: UIControl.State.normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(pickerButtonAction), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerButtonAction() {
        
        print("pickerbuttonaction self.nodes = \(self.nodesArray.count)")
        
        pickerView.show()
    }
    
    //节点数据
    var nodesArray = [[String:String]]()
    
    //节点选择
    var pickerView:ZPHEditPickerView = {
        let picker = ZPHEditPickerView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 250))
        return picker
    }()
    
    //节点once
    var onceString:String?
    //发布节点
    var nodeSelectValue:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        self.setNaviButton()
        self.getNetworkRequest()
    }
    
    private func getNetworkRequest() {
        
        let url = V2EXURL + "/new"
        
        ZPHNetworkTool.networkRequest(url) { (responseString) in
            
            let jiDoc = Ji(htmlString: responseString)
            
            if let nodesDoc = jiDoc?.xPath("//div[@class='box'][@id='box']/form/div[@class='cell']/select/option") {
                
                for node in nodesDoc {
                    
//                    print("node = \(node)")
                    var nodeDict = [String:String]()
                    
                    if let valueString = node.attributes["value"] {
                        
                        nodeDict["value"] = valueString
                        nodeDict["name"] = node.content
                        self.nodesArray.append(nodeDict)
                    }
                }
                
                //传数据
                self.pickerView.nodesArray = self.nodesArray
            }
            
            if let onceDoc = jiDoc?.xPath("//div[@class='box'][@id='box']/form/input[@name='once']")?.first?["value"] {
                
                self.onceString = onceDoc
            }
            
        }
    }
    
    private func setNaviButton() {
        
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(35 + kBottomSafeHeight)
            make.left.equalTo(22)
            make.size.equalTo(CGSize(width: 60, height: 32))
        }
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        self.view.addSubview(releseButton)
        releseButton.snp.makeConstraints { (make) in
            make.top.equalTo(backButton)
            make.right.equalTo(self.view.snp.right).offset(-22)
            make.size.equalTo(backButton)
        }
        releseButton.addTarget(self, action: #selector(releseButtonAction), for: .touchUpInside)
        
        self.view.addSubview(headlineTextfield)
        headlineTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { (make) in
            make.top.equalTo(headlineTextfield.snp.bottom).offset(20)
            make.left.right.equalTo(headlineTextfield)
            make.height.equalTo(70)
        }
        
        //上传图片
        self.view.addSubview(pictureCollectionView)
        pictureCollectionView.backgroundColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        pictureCollectionView.dataSource = self
        pictureCollectionView.delegate = self
        pictureCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.left.right.equalTo(contentTextView)
            make.height.equalTo(pictureCollectionView.snp.width)
        }

        pictureCollectionView.register(ZPHEditCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cellId")
        
        self.view.addSubview(pickerButton)
        pickerButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.pictureCollectionView.snp.bottom).offset(20)
            make.left.right.equalTo(contentTextView)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(pickerView)
        pickerView.determineBlock = { [weak self] (name:String,value:String) in
//            print("name = \(name), value = \(value)")
            self!.pickerButton.setTitle(name, for: .normal)
            self!.nodeSelectValue = value
        }
    }
    
    @objc func backButtonAction() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //发布
    @objc func releseButtonAction() {
        
        //请求
        let param = ["title":headlineTextfield.text,
                     "content":contentTextView.text,
                     "node_name":self.nodeSelectValue,
                     "content":contentTextView.text,
                     "once":self.onceString]
        
        let url = V2EXURL + "/new"
        //回调
        
        ZPHNetworkTool.networkRequest(url, method: .post, parameters: param as Parameters) { (response) in
            
            print(response)
        }
        //成功
        
        //失败
        
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        
        print("ZPHEditViewController -- deinit")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ZPHEditViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.collectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ZPHEditCollectionViewCell
        
        if let img = self.collectionArray[indexPath.row] as? UIImage {
            
            cell.selectImage = img
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if self.collectionArray.count >= 9 {
            return
        }
        
        print("collectionView = \(indexPath.row)")
        
        // 最后一个是加号
        if indexPath.row == self.collectionArray.count - 1 {
            self.selectPicker()
        }
    }
    
    /// 图片选择器
    func selectPicker() {
        
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
    }
}

extension ZPHEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        print(image)
        self.collectionArray.insert(image, at: 0)
        self.pictureCollectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}
