//
//  HJPageView.swift
//  HJPageView
//
//  Created by MrHuang on 17/7/26.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//

import UIKit


class HJPageView: UIView {
    
    
    fileprivate var titles:[String]
    fileprivate var style:HJTitleStyle
    fileprivate var childVC:[UIViewController]!
    fileprivate weak var parentVC:UIViewController!
    
    fileprivate var titleView : HJTitleView!
    fileprivate var ContentView : HJContentView!
    
    //MARK: - 自定义构造函数
    init(frame: CGRect,titles:[String],style:HJTitleStyle,ChildVC:[UIViewController],parentVC:UIViewController) {
        
        self.titles = titles
        self.style = style
        self.childVC = ChildVC
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK:-设置UI
extension HJPageView{
    
    fileprivate func setupUI(){
        
        // titleView
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height:style.titleHeight)
        
        titleView = HJTitleView(frame: titleFrame, titles: titles, style: style)
        
        titleView.delegate = self
        
        addSubview(titleView)
        
        titleView.backgroundColor = UIColor.randomColor()
        
        //contentView
        let ContentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        ContentView = HJContentView(frame: ContentFrame, childVC: childVC, parentVC: parentVC)
        ContentView.delegate = self
        addSubview(ContentView)
        ContentView.backgroundColor = UIColor.randomColor()
    }
    
    
}

//MARK: -遵守ContentViewDelegate
extension HJPageView : HJcontentViewDelegate {
    
    func contentView(_ contentView: HJContentView, currentIndex: Int, targetIndex: Int, progress: CGFloat) {
        titleView.setTitleWithProgress(progress:progress, sourceIndex: currentIndex, targetIndex: targetIndex)
    }
    func TitleLabelEnableScroll(_ contentView: HJContentView) {
        titleView.TitleLabelEnableScroll()
    }
    
}

//MARK: -遵守TitleViewDelegate
extension HJPageView : HJTitleViewDelegate {
    
    func titleView(_ titleView: HJTitleView, selectedIndex index: Int) {
        
        ContentView.contentViewSetupCurrentIndex(index)
        print(index)
    }
    
}
