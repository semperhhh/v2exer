//
//  ZPHNodeTableViewCell.swift
//  v2exer-Swift
//
//  Created by zhangpenghui on 2019/1/30.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHNodeTableViewCell: UITableViewCell {
    
    var model:ZPHNodeModel? {
        didSet {
            
            array = model!.types ?? []
        }
    }
    
    //点击回调
    var collectionCellBack:((_ name: String, _ uri: String)->())?
    
    var array = [ZPHNodeTypeModel]()
    
    var collectionView:UICollectionView!
    
    /// 颜色数组
    let colorArray = [UIColor(red: 120.0/255.0, green: 118.0/255.0, blue: 225.0/255.0, alpha: 1.0),
                      UIColor(red: 236.0/255.0, green: 83.0/255.0, blue: 87.0/255.0, alpha: 1.0),
                      UIColor(red: 245.0/255.0, green: 193.0/255.0, blue: 99.0/255.0, alpha: 1.0),
                      UIColor(red: 194.0/255.0, green: 226.0/255.0, blue: 117.0/255.0, alpha: 1.0),
                      UIColor(red: 101.0/255.0, green: 175.0/255.0, blue: 243.0/255.0, alpha: 1.0),
                      UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1.0)
                        ]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize.init(width: kScreenWidth / 4, height: kScreenWidth / 4)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.collectionView.bounces = false
        self.collectionView.backgroundColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isScrollEnabled = false
        self.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        let nib = UINib(nibName: "ZPHNodeCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZPHNodeTableViewCell:UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = array[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! ZPHNodeCollectionCell
        cell.model = model
        
        cell.headLabel.backgroundColor = colorArray[self.model?.headColor ?? 0]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = self.array[indexPath.row]
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //回调
        if self.collectionCellBack != nil {
            self.collectionCellBack!(model.name!,model.uri!)
        }
    }
}
