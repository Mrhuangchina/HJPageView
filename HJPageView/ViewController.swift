//
//  ViewController.swift
//  HJPageView
//
//  Created by MrHuang on 17/7/26.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        automaticallyAdjustsScrollViewInsets = false
        
        //                let titles = ["游戏", "娱乐", "趣玩", "美女", "颜值"]
        let titles = ["游戏", "娱乐娱乐娱乐", "趣玩", "美女女", "颜值颜值", "趣玩", "美女女", "颜值颜值"]
        let style = HJTitleStyle()
        style.isScrollEnable = true
        style.isShowBottomLine = true
        style.isNeedScale = true
        style.isShowCover = true
        
        
        //所得子控制器
        var ChildVCs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            ChildVCs.append(vc)
            
        }
        
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height-64)
        
        let pageView = HJPageView(frame:pageFrame,titles:titles,style:style,ChildVC:ChildVCs,parentVC:self)
        
        view .addSubview(pageView)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

