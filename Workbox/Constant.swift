//
//  Constant.swift
//  Workbox
//  公共常量
//  Created by 刘海 on 2016/12/30.
//  Copyright © 2016年 刘海. All rights reserved.
//

import Foundation
import UIKit

//屏幕分辨率
public let screenObject=UIScreen.main.bounds;
//每毫米像素数 retina
public let lineCMSpacing = 6.057613;
//没英寸像素数 retina
public let lineINCHSpacing = 15.386337;

public let NUMBERS = "0123456789."

//截取places位小数
public func floorToPlaces(value:Double, places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return floor(value * divisor) / divisor
}

public func AngleToRadian(angle : CGFloat) ->CGFloat { return (CGFloat(M_PI)/180.0)*angle}

public func RadianToAngle(angle : CGFloat) ->CGFloat { return (180.0/CGFloat(M_PI))*angle}

public func Color(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor{
    return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha);
}

public func validateNumber(number:NSString) -> Bool{
    
    var res = true;
    let tmpSet = CharacterSet(charactersIn: NUMBERS);
    
    var i = 0;
    while i < number.length {
        let string = number.substring(with: NSRange(location: i, length: 1));
        let range = string.rangeOfCharacter(from: tmpSet);
        if range == nil {
            res = false;
            break;
        }
        i += 1;
    }
    
    return res;
}



