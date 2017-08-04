//
//  HJContentView.swift
//  HJPageView
//
//  Created by MrHuang on 17/7/26.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//

import UIKit

//MARK: -协议
@objc protocol HJcontentViewDelegate : class  {
    
    func contentView(_ contentView:HJContentView,currentIndex : Int,targetIndex : Int,progress : CGFloat)
    
    @objc optional func TitleLabelEnableScroll(_ contentView:HJContentView)
    
}

fileprivate let kCellId = "cellID"

class HJContentView: UIView {
    
    fileprivate var ChildVC:[UIViewController]
    fileprivate var parenVC:UIViewController
    
    fileprivate var startOffsetX : CGFloat = 0
    //是否重复响应拖动和点击的代理方法，
    fileprivate var isRepeatScrollDelegate : Bool = false
    
    weak var delegate : HJcontentViewDelegate?
    
    fileprivate lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        
        let colletionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        
        colletionView.scrollsToTop = false
        colletionView.bounces = false
        colletionView.isPagingEnabled = true
        colletionView.showsHorizontalScrollIndicator = false
        colletionView.showsVerticalScrollIndicator = false
        
        colletionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellId)
        
        colletionView.dataSource = self
        colletionView.delegate = self
        
        return colletionView
    }()
    
    //MARK: -自定义构造函数
    init(frame: CGRect,childVC:[UIViewController],parentVC:UIViewController) {
        
        self.ChildVC = childVC
        self.parenVC = parentVC
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -设置UI界面
extension HJContentView {
    
    fileprivate func setupUI(){
        
        // 将所有自控制器添加到父控制中
        for vc in ChildVC {
            parenVC.addChildViewController(vc)
        }
        //添加collectionView
        addSubview(collectionView)
        
        
        
    }
    
    
}

//MARK: -CollectionViewDelegate
extension HJContentView : UICollectionViewDelegate {
    
    //停止减速的时候开始执行
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        delegate?.TitleLabelEnableScroll?(self)
        scrollView.isScrollEnabled = true
        
    }
    
    //停止拖拽的时候开始执行
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate{
            
            
            delegate?.TitleLabelEnableScroll?(self)
        } else {
            scrollView.isScrollEnabled = false
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isRepeatScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //判断是否为点击事件，拖动和点击会产生重复的点击事件
        if isRepeatScrollDelegate { return }
        
        //定义目标Label的targetIndex 和 progress
        var targetIndex : Int = 0
        var progress : CGFloat = 0.0
        
        //当前位置的下标
        let currentIndex = Int(startOffsetX / scrollView.bounds.size.width)
        
        if startOffsetX < scrollView.contentOffset.x {//左滑动
            
            targetIndex = currentIndex + 1
            
            // //防止过度滑动越界 最后一个子控制器的下标
            if targetIndex > ChildVC.count - 1 {
                
                targetIndex = ChildVC.count - 1
            }
            
            //进度值
            progress = (scrollView.contentOffset.x - startOffsetX) / scrollView.bounds.size.width
        }else{//右滑动
            
            targetIndex = currentIndex - 1
            
            //防止过度滑动越界 第一个子控制器的下标
            if targetIndex < 0 {
                targetIndex = 0
            }
            //进度值
            progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.size.width
        }
        
        delegate?.contentView(self, currentIndex: currentIndex, targetIndex: targetIndex, progress: progress)
        
    }
    
    
}



//MARK: -CollectionViewDataSource
extension  HJContentView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return ChildVC.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath)
        //在添加子控制之前，把之前添加的删除，否则会一直叠加在里面
        for subVC in cell.contentView.subviews {
            subVC.removeFromSuperview()
        }
        
        let childVC = ChildVC[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
}

//MARK: -设置ContentView的Index对外方法
extension HJContentView {
    
    func contentViewSetupCurrentIndex(_ Currentindex : Int) {
        // 记录需要进行的点击事件
        isRepeatScrollDelegate = true
        
        //滚动到的位置
        let offSetX = CGFloat(Currentindex) * collectionView.frame.size.width
        collectionView.setContentOffset(CGPoint(x:offSetX,y:0), animated: false)
        
    }
    
}
