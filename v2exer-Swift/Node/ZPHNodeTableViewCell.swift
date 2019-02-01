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
    
    var collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize.init(width: 80, height: 44)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.bounces = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        self.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (mark) in
            mark.edges.equalTo(self.contentView)
        }
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ZPHNodeTableViewCell:UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = array[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        label.text = model.name
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(cell.contentView)
            make.width.equalTo(cell.contentView.bounds.size.width)
        }
        cell.backgroundColor = UIColor.init(red: 99.0/255.0, green: 166.0/255.0, blue: 48.0/255.0, alpha: 1.0)
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
