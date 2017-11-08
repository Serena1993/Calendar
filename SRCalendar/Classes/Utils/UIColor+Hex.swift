//
//  UIColor+Hex.swift
//  Calendar
//
//  Created by Ruihaha on 17/3/3.
//  Copyright © 2017年 Serena_Li_Rui_93. All rights reserved.
//

import Foundation
import UIKit

/**
 UIColor的16进制颜色扩展，
 可以直接把设计的16进制颜色字符串转成UIColor
 */
extension UIColor {
    
    // MARK: - 3，4，6，8位rgba/argb私有构造器
    fileprivate convenience init(hex3: UInt16, alpha: CGFloat = 1.0) {
        
        let divisor: CGFloat = 15
        
        let red     = CGFloat((hex3 & 0xF00) >> 8) / divisor
        let green   = CGFloat((hex3 & 0x0F0) >> 4) / divisor
        let blue    = CGFloat( hex3 & 0x00F      ) / divisor
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
        
    }
    
    fileprivate convenience init(hex4rgba: UInt16) {
        
        let divisor: CGFloat = 15
        
        let hex3 = (hex4rgba >> 4) & 0x0FFF
        let alpha = CGFloat(hex4rgba & 0x000F) / divisor
        
        self.init(hex3: hex3, alpha: alpha)
        
    }
    
    fileprivate convenience init(hex6: UInt32, alpha: CGFloat = 1.0) {
        
        let divisor: CGFloat = 255
        
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
        
    }
    
    fileprivate convenience init(hex8rgba: UInt32) {
        
        let divisor: CGFloat = 255
        
        let hex6 = (hex8rgba >> 8) & 0x00FFFFFF
        let alpha = CGFloat(hex8rgba & 0x000000FF) / divisor
        
        self.init(hex6: hex6, alpha: alpha)
        
    }
    
    fileprivate convenience init(hex4argb: UInt16) {
        
        let divisor: CGFloat = 15
        
        let hex3 = hex4argb & 0x0FFF
        let alpha = CGFloat(hex4argb >> 12) / divisor
        
        self.init(hex3: hex3, alpha: alpha)
        
    }
    
    fileprivate convenience init(hex8argb: UInt32) {
        
        let divisor: CGFloat = 255
        
        let hex6 = hex8argb & 0x00FFFFFF
        let alpha = CGFloat(hex8argb >> 24) / divisor
        
        self.init(hex6: hex6, alpha: alpha)
        
    }
    
    // MARK: - 16进制颜色构造入口
    /**
     从16进制的颜色串，创建UIColor
     - Parameters:
     - hexColor: 16进制颜色字符串，支持3位，6位不带alpha的颜色值，也支持4位，8位带alpha的颜色值
     - isRGBA: 标示hexColor参数的字符串格式是RGBA还是ARGB，默认是RGBA格式
     - Returns: 如果hexColor指定的16进制颜色字符串有效，则返回UIColor，否则返回nil
     */
    public convenience init?(hexColor: String, isRGBA: Bool = true) {
        
        var hexStr = hexColor
        
        //有没有#号都可以使用
        if hexColor.hasPrefix("#") {
            
            let index = hexColor.index(hexColor.startIndex, offsetBy: 1)
            hexStr = hexColor.substring(from: index)
            
        }
        
        var hexValue: UInt32 = 0
        
        let scanner = Scanner(string: hexStr)
        
        if scanner.scanHexInt32(&hexValue) {
            
            switch hexStr.characters.count {
                
            case 3:
                
                self.init(hex3: UInt16(hexValue))
                
            case 4:
                
                if isRGBA {
                    
                    self.init(hex4rgba: UInt16(hexValue))
                    
                }
                else {
                    
                    self.init(hex4argb: UInt16(hexValue))
                    
                }
                
            case 6:
                
                self.init(hex6: hexValue)
                
            case 8:
                
                if isRGBA {
                    
                    self.init(hex8rgba: hexValue)
                    
                }
                else {
                    
                    self.init(hex8argb: hexValue)
                    
                }
                
            default:
                
                return nil
                
            }
            
        }
        else {
            
            return nil
            
        }
        
    }
    
}
