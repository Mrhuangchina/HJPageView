//
//  UIColor-Extension.swift
//  HJPageView
//
//  Created by MrHuang on 17/7/26.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    //在extension中给系统的类扩充构造函数，只能扩充“便利构造函数”
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat = 1.0) {
        
        self.init(red: r/255.0, green:g/255.0, blue: b/255.0, alpha: alpha)
        
    }
    
    //传入十六进制色彩
    convenience init?(hex:String,alpha:CGFloat = 1.0) {
        
        // 1. 判断输入的十六进制是否长度大于等于6 小于6则不是十六进制
        guard hex.characters.count>=6 else {
            
            return nil
        }
        // 2.将字符串转换成大写
        var temHex = hex.uppercased()
        
        // 3.判断开头是 #/0x/##
        //如果开头是以0x/## 开头 则在下标为2的位置开始截取字符串
        if temHex.hasPrefix("0x") || temHex.hasPrefix("##") {
            temHex = (temHex as NSString).substring(to: 2)
        }
        //如果是以#开头 则下标位置为1的开始截取字符串
        if temHex.hasPrefix("#") {
            temHex = (temHex as NSString).substring(to: 1)
        }
        
        // 4.分别取出RGB 例如FF002D FF：红 00:绿 2D:蓝
        
        var range = NSRange(location:0,length:2)
        let redHex = (temHex as NSString).substring(with:range)
        range.location = 2
        let greenHex = (temHex as NSString).substring(with: range)
        range.location = 4
        let blueHex = (temHex as NSString).substring(with: range)
        
        // 5.将十六进制转换成数字
        
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        Scanner(string:redHex).scanHexInt32(&r)
        Scanner(string:greenHex).scanHexInt32(&g)
        Scanner(string:blueHex).scanHexInt32(&b)
        
        self.init(r:CGFloat(r),g:CGFloat(g),b:CGFloat(b))
        
    }
    
    
    // 随机色
    class func randomColor() -> UIColor {
        
        return UIColor(r:CGFloat(arc4random_uniform(255)),g:CGFloat(arc4random_uniform(255)),b:CGFloat(arc4random_uniform(255)))
        
    }
    
    
    //RGB颜色差值
    class func getRGBdifferencevalue(_ firstColor:UIColor,_ secondColor:UIColor)->(r:CGFloat,g:CGFloat,b:CGFloat){
        
        let firstColor = firstColor.getRGB()
        let secondColor = secondColor.getRGB()
        
        return(r:firstColor.0-secondColor.0,g:firstColor.1-secondColor.1,b:firstColor.2-secondColor.2)
    }
    
    // 取出RGB值
    func getRGB()->(r:CGFloat,g:CGFloat,b:CGFloat){
        //components 为一个颜色通道的数组 可选类型
        guard let cmps = cgColor.components else {
            
            fatalError("请检查传入的颜色是否为RGB形式的值！！！")
            
        }
        
        return (r:cmps[0]*255,g:cmps[1]*255,b:cmps[2]*255)
    }
    
    
}
