//
//  HJPageCollectionView.swift
//  HJPageView拓展
//
//  Created by MrHuang on 17/7/28.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//

import UIKit

//MARK: -设置HJPageCollectionViewDataSource
protocol HJPageCollectionViewDataSource : class {
    
    func numberOfSections(in pageCollectionView: HJPageCollectionView) -> Int
    func pageCollectionView(_ collectionView: HJPageCollectionView, numberOfItemsInSection section: Int) -> Int
    func pageCollectionView(_ pageCollectionView: HJPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
}

protocol HJPageCollectionViewDelegate : class {
    
    func pageCollectionView(_ pageCollectionView: HJPageCollectionView, didSelectItemAt indexPath: IndexPath)
    
}


class HJPageCollectionView: UIView {
    
    weak var datasource : HJPageCollectionViewDataSource?
    weak var delegate : HJPageCollectionViewDelegate?
    
    fileprivate var titles : [String]
    fileprivate var style : HJTitleStyle!
    fileprivate var isTitleInTop : Bool
    fileprivate var layout : HJPageCollectionLayout
    fileprivate var collectionView : UICollectionView!
    fileprivate var pageControl : UIPageControl!
    fileprivate var sourceIndexpath : IndexPath = IndexPath(item: 0, section: 0)
    fileprivate var titleView : HJTitleView!
    
    init(frame: CGRect,titles : [String], style : HJTitleStyle, isTitleInTop : Bool,layout: HJPageCollectionLayout) {
        
        self.titles = titles
        self.style = style
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
}



extension HJPageCollectionView {
    
    fileprivate func setupUI(){
    
        // 1.创建titleView
        let titleY = isTitleInTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleHeight)
            titleView = HJTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.delegate = self
        titleView.backgroundColor = UIColor.randomColor()
        addSubview(titleView)
        
        // 2.创建UIPageControl
        let pageHeight : CGFloat = 20
        let pageY = isTitleInTop ? (bounds.height - pageHeight) :(bounds.height - pageHeight - style.titleHeight)
        let pageFrame = CGRect(x: 0, y: pageY, width: bounds.width, height: pageHeight )
           pageControl = UIPageControl(frame: pageFrame)
        pageControl.numberOfPages = 4
        pageControl.isEnabled = false
        pageControl.backgroundColor = UIColor.randomColor()
        addSubview(pageControl)
        
        // 3.创建CollectionView
        let collectionY = isTitleInTop ? style.titleHeight : 0
        let collectionFrame = CGRect(x: 0, y: collectionY, width: bounds.width, height: bounds.height - pageHeight - style.titleHeight)
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.randomColor()
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
       
        
        addSubview(collectionView)
    }

}

//MARK: -对外暴露的方法 注册cell
extension HJPageCollectionView {
    
    func register(cell : AnyClass?, identifier : String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    func register(nib : UINib, identifier : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    
    
}


//MARK: -UICollectionViewDataSource
extension HJPageCollectionView : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return datasource?.numberOfSections(in: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemCount = datasource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        
        if section == 0 {
        
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            
        }
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        return  datasource!.pageCollectionView(self, collectionView, cellForItemAt: indexPath)
    }
    
}

//MARK: -UICollectionViewDelegate
extension HJPageCollectionView : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(self, didSelectItemAt: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        scrollViewEndscroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
        
            scrollViewEndscroll()
        }
    }
    
       fileprivate func scrollViewEndscroll() {
        
        // 1. 取出cell当前的位置
        let point = CGPoint(x: layout.sectionInset.left + collectionView.contentOffset.x + 1, y: layout.sectionInset.top + 1)
        guard  let cellindexPath = collectionView.indexPathForItem(at: point) else { return }
        
        // 2. 判断分组是否发生了变化
        if sourceIndexpath.section != cellindexPath.section {
            // 2.1修改pageControl的个数
            let itemCount = datasource?.pageCollectionView(self, numberOfItemsInSection: cellindexPath.section) ?? 0
            
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            
            // 2.2调整titleView的位置
            titleView.setTitleWithProgress(progress: 1.0, sourceIndex: sourceIndexpath.section, targetIndex: cellindexPath.section)
            
            // 2.3 记录最新indexPath值
            sourceIndexpath = cellindexPath
        }
        // 3.根据idexPath设置pageControl
        pageControl.currentPage = cellindexPath.item / (layout.cols * layout.rows)
    }
}

//MARK: -titleViewDeleagate 
extension HJPageCollectionView : HJTitleViewDelegate {
    
    func titleView(_ titleView: HJTitleView, selectedIndex index: Int) {
        
        let sectionindex = IndexPath(item: 0, section: index)
        collectionView.scrollToItem(at: sectionindex, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        scrollViewEndscroll()
    }

}
