//
//  HJPageCollectionLayout.swift
//  HJPageView拓展
//
//  Created by MrHuang on 17/7/28.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//

import UIKit

class HJPageCollectionLayout: UICollectionViewFlowLayout {
    
        var cols : Int = 4
        var rows : Int = 2
    fileprivate lazy var attricell : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var maxWidth : CGFloat = 0
}

extension HJPageCollectionLayout {
    
    override func prepare() {
        super.prepare()
        
        // 0. 计算item的宽度&高度
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(cols - 1)) / CGFloat(cols)
        let itemH = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing * CGFloat(rows - 1)) / CGFloat(rows)
        
        // 1. 获取有多少section
        let sectionCount = collectionView!.numberOfSections
        
        // 2. 每个section中有多少Item
        var prePageCount : Int = 0
        for i in 0..<sectionCount {
            
            let itemCount = collectionView!.numberOfItems(inSection: i)
            
            for j in 0..<itemCount {
                
                // 2.1 获取cell 对应的indexpath
                let indexpath = IndexPath(item: j, section: i)
                
                // 2.2 根据indexpath创建对应的UICollectionViewLayoutAttributes
                let attri = UICollectionViewLayoutAttributes(forCellWith: indexpath)
                
                // 2.3 计算j在该组中第几页
                let page = j / (cols * rows)
                let index = j % (cols * rows)
                
                let itemY = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(index / cols)
                let itemX = CGFloat(prePageCount + page) * collectionView!.bounds.width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(index % cols)
                
                attri.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                
                attricell.append(attri)
            }
            
            prePageCount += (itemCount - 1) / (cols * rows) + 1
        }
        
        // 3.计算最大宽度
        maxWidth = CGFloat(prePageCount) * collectionView!.bounds.width

    }

}

extension HJPageCollectionLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        return attricell
    }
}

extension HJPageCollectionLayout {
    
    override var collectionViewContentSize: CGSize{
    
        return CGSize(width: maxWidth, height: 0)
    }
}
