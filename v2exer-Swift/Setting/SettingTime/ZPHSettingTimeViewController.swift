//
//  ZPHSettingTimeViewController.swift
//  v2exer-Swift
//
//  Created by 张鹏辉 on 2019/4/1.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPHSettingTimeViewController: UIViewController {
    
    private var collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
