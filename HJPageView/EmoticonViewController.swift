//
//  EmoticonViewController.swift
//  HJPageView
//
//  Created by MrHuang on 17/8/4.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//

import UIKit


let kEmoticonCell = "kEmoticonCellID"

class EmoticonViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pageFrame = CGRect(x: 50, y: 100, width: 300, height: 400)
        
        let titles = ["土豪", "热门", "专属", "常见"]
        let style = HJTitleStyle()
        style.isShowBottomLine = true
        let layout = HJPageCollectionLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        //        layout.cols = 8
        //        layout.rows = 3
        
        let pageView = HJPageCollectionView(frame: pageFrame, titles: titles, style: style, isTitleInTop: true, layout: layout)
        
        pageView.datasource = self
        pageView.delegate = self
        pageView.register(cell: UICollectionViewCell.self, identifier: kEmoticonCell)
        
        view.addSubview(pageView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension UIViewController : HJPageCollectionViewDataSource,HJPageCollectionViewDelegate{
    
    func numberOfSections(in pageCollectionView: HJPageCollectionView) -> Int {
        
        return 4
    }
    func pageCollectionView(_ collectionView: HJPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 18
        }
        
        return 25
    }
    func pageCollectionView(_ pageCollectionView: HJPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCell, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        
        return cell
    }
    
    func pageCollectionView(_ pageCollectionView: HJPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath)
    }
}
