//
//  ProtractorNoniusView.swift
//  Workbox
//
//  Created by 刘海 on 2016/12/31.
//  Copyright © 2016年 刘海. All rights reserved.
//

import UIKit

class ProtractorNoniusView: MainUIView {
    
    var radius:         CGFloat!;
    var startPoint:     CGPoint!;
    var controlRing:    UIBezierPath!;
    
    //声明一个属性Block，type为闭包可选类型
    //闭包类型：(UIView)->(UIView) ，参数是本身View，返回本身View
    var MoveBlock:(()->Swift.Void)?;
    
    override init(frame : CGRect){
        super.init(frame: frame);
        
        radius = ((screenObject.height - 64 - 80.0) / 2.0 - 10.0) / 2.0;
        
        self.backgroundColor = UIColor.clear;
        
        let iconImage = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height));
        iconImage.image = UIImage(named: "angleyb");
        self.addSubview(iconImage);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
            startPoint = touch.location(in: self);
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch:AnyObject in touches{
            let movePoint:CGPoint = touch.location(in: self);
            
            let offsetX = movePoint.x - startPoint.x;
            let offsetY = movePoint.y - startPoint.y;
            
            let centerX = self.center.x + offsetX;
            let centerY = self.center.y + offsetY
            
            let center:CGPoint = CGPoint(x: 0, y: (screenObject.height - 64.0) / 2.0);
            
            let distance:CGFloat = sqrt(pow(center.x - centerX, 2) + pow(centerY - center.y,2));
            
            
            var x:CGFloat = center.x - radius / distance * (center.x - centerX);
            let y:CGFloat = center.y + radius / distance * (centerY - center.y);
            
            //y可移动区间
            let a:CGFloat = (screenObject.height - 64.0 - radius * 2.0) / 2.0;
            let b:CGFloat = a + radius * 2.0;
            if x <= 0 {
                x = 0;
            }
            if x == 0 {
                if y >= a || y <= b {
                    return;
                }
            }
            self.center = CGPoint(x: x, y: y);
            
            if self.MoveBlock != nil {
                self.MoveBlock!();
            }
        }
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
