//
//  HJTitltView.swift
//  HJPageView
//
//  Created by MrHuang on 17/7/26.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//

import UIKit

protocol HJTitleViewDelegate : class {
    func titleView(_ titleView : HJTitleView,selectedIndex index:Int)
}

class HJTitleView: UIView {
    
    fileprivate var titles:[String]!
    fileprivate var style:HJTitleStyle!
    
    weak var delegate : HJTitleViewDelegate?
    
    //存储Label的数组
    fileprivate lazy var labels : [UILabel] = [UILabel]()
    //记录当前的下标
    fileprivate var currentIndex : Int = 0
    //MARK: -控件属性
    //scrollView
    fileprivate lazy var scrollView : UIScrollView = {
        
        let scrollView = UIScrollView()
        
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.scrollsToTop = false
        
        return scrollView
        
    }()
    
    //分割线
    fileprivate lazy var CutLine : UIView = {
        
        let cutLineHeight : CGFloat = 0.5
        
        let cutLine = UIView()
        cutLine.backgroundColor = UIColor.lightGray
        cutLine.frame = CGRect(x: 0, y: self.bounds.height - cutLineHeight, width: self.bounds.width, height: cutLineHeight)
        
        return cutLine
    }()
    
    //底部滚动条
    fileprivate lazy var BottomLine : UIView = {
        
        let BottomLine = UIView()
        BottomLine.backgroundColor = self.style.BottomLineColor
        
        return BottomLine
    }()
    
    //遮盖视图
    fileprivate lazy var CoverView : UIView = {
        
        let coverView = UIView()
        coverView.backgroundColor = self.style.CoverColor
        coverView.alpha = 0.7
        
        return coverView
    }()
    
    // 颜色计算
    fileprivate lazy var normalColorRGB:(r:CGFloat,g:CGFloat,b:CGFloat) = self.getRGBColor(self.style.normalColor)
    fileprivate lazy var selectColorRGB:(r:CGFloat,g:CGFloat,b:CGFloat) = self.getRGBColor(self.style.selectColor)
    
    
    //MARK: -自定义构造函数
    init(frame: CGRect,titles:[String],style:HJTitleStyle) {
        
        self.titles = titles
        self.style = style
        
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


//MARK: -设置UI
extension HJTitleView{
    
    fileprivate func setupUI(){
        
        // 1. 添加scrollView
        addSubview(scrollView)
        
        // 2. 添加分割线
        addSubview(CutLine)
        
        // 3. 设置所有的标题Label
        setupLabels()
        // 4. 设置Label的Frame
        setupLaeblFrame()
        
        //添加滚动条
        if style.isShowBottomLine {
            setupBottomLine()
        }
        // 遮盖
        if style.isShowCover {
            setupCoverView()
        }
        
    }
    
    // 设置Label
    fileprivate func setupLabels(){
        
        for (i,title) in titles.enumerated() {
            
            let label = UILabel()
            label.tag = i
            label.text = title
            label.textAlignment = .center
            label.textColor = i == 0 ? style.selectColor : style.normalColor
            label.font = style.font
            
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(LabelClickTap(_:)))
            
            label.addGestureRecognizer(tap)
            
            labels.append(label)
            scrollView.addSubview(label)
            
        }
        
    }
    
    // 设置Label的Frame
    fileprivate func setupLaeblFrame(){
        
        var titleW : CGFloat = 0
        let titleH : CGFloat = bounds.height
        var titleX : CGFloat = 0
        let titleY : CGFloat = 0
        
        let count = titles.count
        
        for (index,titleLaebel) in labels.enumerated() {
            
            if style.isScrollEnable {
                
                //字体的宽度来计算label的宽度
                titleW = (titles[index] as NSString).boundingRect(with: CGSize(width:CGFloat(MAXFLOAT),height:0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:style.font], context: nil).width
                
                
                if index == 0 {//第一个Label
                    
                    titleX = style.Margin * 0.5
                    
                    if style.isShowBottomLine {
                        
                        BottomLine.frame.origin.x = titleX
                        BottomLine.frame.size.width = titleW
                    }
                    
                }else{
                    
                    //如果不是第一个label  则labels数组则要减去刚刚的第一个已经设置好的label数量
                    let parlabel = labels[index - 1]
                    titleX = parlabel.frame.maxX + style.Margin
                }
                
            }else{//不能滚动
                
                titleW = frame.width / CGFloat(count)
                titleX = CGFloat(index) * titleW
                
                if index == 0 && style.isShowBottomLine {
                    
                    BottomLine.frame.origin.x = titleX
                    BottomLine.frame.size.width = titleW
                    
                }
            }
            
            
            titleLaebel.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            
            //放大
            if index == 0 {
                
                let scale = self.style.isNeedScale ? style.ScaleRange : 1.0
                
                titleLaebel.transform = CGAffineTransform(scaleX:scale,y:scale)
            }
            
        }
        
        //如果可以滚动 则设置scrollView的contenSize
        scrollView.contentSize = style.isScrollEnable ? CGSize(width:labels.last!.frame.maxX + style.Margin * 0.5 , height: 0) : CGSize.zero
        
    }
    
    // 设置底部滚动条
    fileprivate func setupBottomLine(){
        scrollView.addSubview(BottomLine)
        BottomLine.frame = labels.first!.frame
        BottomLine.frame.size.height = style.BottomLineHeight
        BottomLine.frame.origin.y = bounds.height - style.BottomLineHeight
    }
    
    //设置遮盖视图
    fileprivate func setupCoverView(){
        
        scrollView.insertSubview(CoverView, at: 0)
        
        let firtLabel = labels[0]
        let coverH : CGFloat = self.style.CoverHeight
        var coverW : CGFloat = firtLabel.frame.size.width
        var coverX : CGFloat = firtLabel.frame.origin.x
        let coverY : CGFloat = (frame.size.height - self.style.CoverHeight) * 0.5
        
        if style.isScrollEnable {
            
            coverX -= style.CoverMargin
            coverW += style.CoverMargin * 2
            
        }
        
        CoverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        CoverView.layer.cornerRadius = style.CoverRadius
        CoverView.layer.masksToBounds = true
        
    }
    
    
}

//MARK: -响应label的点击事件
extension HJTitleView{
    
    @objc fileprivate func LabelClickTap( _ tapGes:UIGestureRecognizer){
        
        //取出用户点击的Label
        guard  let currentLabel = tapGes.view as? UILabel else {return}
        
        //如果用户点击的是同一个label 则直接返回
        if currentLabel.tag == currentIndex { return}
        
        //获取之前的Label
        let oldLable = labels[currentIndex]
        
        //交换被选中的颜色
        oldLable.textColor = style.normalColor
        currentLabel.textColor = style.selectColor
        
        // 记录当前被选中的下标
        currentIndex = currentLabel.tag
        
        
        //代理通知
        delegate?.titleView(self, selectedIndex: currentIndex)
        print(currentIndex)
        
        
        //被选中的label滚动到中间
        TitleLabelEnableScroll()
        
        //调整样式
        
        if style.isShowBottomLine {
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.BottomLine.frame.origin.x = currentLabel.frame.origin.x
                self.BottomLine.frame.size.width = currentLabel.frame.size.width
            })
        }
        
        if style.isNeedScale {
            
            oldLable.transform = CGAffineTransform.identity
            currentLabel.transform = CGAffineTransform(scaleX: style.ScaleRange, y: style.ScaleRange)
        }
        
        if style.isShowCover {
            
            let coverX = style.isScrollEnable ? (currentLabel.frame.origin.x - style.CoverMargin) : currentLabel.frame.origin.x
            let coverW = style.isScrollEnable ? (currentLabel.frame.width + style.CoverMargin * 2) : currentLabel.frame.width
            UIView.animate(withDuration: 0.2, animations: {
                self.CoverView.frame.origin.x = coverX
                self.CoverView.frame.size.width = coverW
            })
            
            
        }
        
        
        
        
    }
}

//MARK: -对外调用的方法
extension HJTitleView {
    
    func setTitleWithProgress(progress : CGFloat, sourceIndex : Int, targetIndex:Int) {
        
        //取出当前Label 和 目标Label
        let sourceLabel = labels[sourceIndex]
        let targetLabel = labels[targetIndex]
        
        
        
        //颜色差值
        let diffVulesColor = (selectColorRGB.0 - normalColorRGB.0,selectColorRGB.1 - normalColorRGB.1,selectColorRGB.2 - normalColorRGB.2)
        //颜色变化
        sourceLabel.textColor = UIColor(r:selectColorRGB.0 - diffVulesColor.0 * progress,g:selectColorRGB.1 - diffVulesColor.1 * progress, b:selectColorRGB.2 - diffVulesColor.2 * progress)
        targetLabel.textColor = UIColor(r:normalColorRGB.0 + diffVulesColor.0 * progress,g:normalColorRGB.1 + diffVulesColor.1 * progress ,b: normalColorRGB.2 + diffVulesColor.2 * progress)
        //记录最新的Index
        currentIndex = targetIndex
        
        //移动位置差值
        let moveToX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveToW = targetLabel.frame.width - sourceLabel.frame.width
        
        //计算 滚动条的移动范围
        if style.isShowBottomLine {
            
            BottomLine.frame.origin.x = sourceLabel.frame.origin.x + moveToX * progress
            BottomLine.frame.size.width = sourceLabel.frame.size.width + moveToW * progress
            
        }
        
        // 计算放大的效果
        if style.isNeedScale {
            
            let diffScale = (style.ScaleRange - 1.0) * progress
            sourceLabel.transform = CGAffineTransform(scaleX: style.ScaleRange - diffScale, y: style.ScaleRange - diffScale)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + diffScale,y: 1.0 + diffScale)
            
        }
        
        // 计算遮盖视图滚动
        
        if style.isShowCover {
            
            CoverView.frame.origin.x = style.isScrollEnable ? (sourceLabel.frame.origin.x - style.CoverMargin + moveToX * progress) : (sourceLabel.frame.origin.x + moveToX * progress)
            CoverView.frame.size.width = style.isScrollEnable ? (sourceLabel.frame.size.width + 2 * style.CoverMargin + moveToW * progress) : (sourceLabel.frame.size.width + moveToW * progress)
            
        }
        
    }
    
    
    //MARK: -设置被选中的Label自动滚动到中间
    func TitleLabelEnableScroll(){
        
        //判断样式是否需要滚动 如果样式需不需滚动 如果不需要则TitleLabel不需要滚动到中间
        guard  style.isScrollEnable else { return }
        
        //获取目标Label
        let targetLabel = labels[currentIndex]
        
        //计算目标Label 和 中间位置的偏移量
        var offSetx = targetLabel.center.x - bounds.width * 0.5
        
        // 左边临界值 如果偏移量小于0 则把偏移量设置为0 这样第一个Label就无法滚动到中间
        if offSetx < 0 {
            
            offSetx = 0
            //右边临界值 最大偏移值=内容视图-宽度  这样不会导致最后一个滚到中间
        }else if offSetx > scrollView.contentSize.width - scrollView.bounds.width{
            
            offSetx = scrollView.contentSize.width - scrollView.bounds.width
        }
        
        scrollView.setContentOffset(CGPoint(x:offSetx,y:0), animated: true)
    }
    
}

//MARK: - 颜色差值
extension HJTitleView {
    
    //RGB颜色差值
    fileprivate func getRGBColor(_ Color:UIColor)->(r:CGFloat,g:CGFloat,b:CGFloat){
        
        guard let color = Color.cgColor.components else {
            fatalError("请检查传入的颜色是否为RGB形式的值！！！")
        }
        
        
        return(r:color[0] * 255,g:color[1] * 255,b:color[2] * 255)
    }
    
}
