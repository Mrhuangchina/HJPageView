//
//  HJTitleStyle.swift
//  HJPageView
//
//  Created by MrHuang on 17/7/26.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//

import UIKit

class HJTitleStyle {
    
    //是否可以滚动
    var isScrollEnable : Bool = false
    //titleView的高度
    var titleHeight : CGFloat = 44
    //默认的文字颜色
    var normalColor : UIColor = UIColor(r: 0, g: 0, b: 0)
    //选中的文字颜色
    var selectColor : UIColor = UIColor(r: 255, g: 127, b: 0)
    //字体大小
    var font : UIFont = UIFont.systemFont(ofSize: 14)
    //间距
    var Margin : CGFloat = 20
    
    
    //是否显示底部滚动条
    var isShowBottomLine : Bool = false
    // 底部滚动条颜色
    var BottomLineColor : UIColor = UIColor(r: 255, g: 127, b: 0)
    //滚动条高度
    var BottomLineHeight : CGFloat = 2.0
    
    //是否进行缩放
    var isNeedScale : Bool = false
    //缩放大小
    var ScaleRange : CGFloat = 1.2
    
    //是否显示遮盖
    var isShowCover : Bool = false
    //遮盖的高度
    var CoverHeight : CGFloat = 25
    //遮盖的颜色
    var CoverColor : UIColor = UIColor.white
    //遮盖与文字的间隙
    var CoverMargin : CGFloat = 5
    //遮盖的圆角
    var CoverRadius : CGFloat = 12
    
}
