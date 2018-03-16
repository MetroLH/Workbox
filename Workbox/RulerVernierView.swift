//
//  RulerVernierView.swift
//  Workbox
//
//  Created by 刘海 on 2016/12/30.
//  Copyright © 2016年 刘海. All rights reserved.
//

import UIKit

class RulerVernierView: MainUIView {

    var startPoint: CGPoint!;
    
    
    //声明一个属性Block，type为闭包可选类型
    //闭包类型：(UIView)->(UIView) ，参数是本身View，返回本身View
    var MoveBlock:(()->Swift.Void)?;

    override init(frame : CGRect){
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.clear;
        
        let image:UIImageView = UIImageView(frame: CGRect(x: (frame.width - 56.0) / 2.0, y: (frame.height - 15.0) / 2.0, width: 56.0, height: 15.0));
        image.image = UIImage(named: "ruleryb");
        self.addSubview(image);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext(){
            context.setLineCap(CGLineCap.round);
            context.setLineWidth(1);
            context.setAllowsAntialiasing(true);
            context.setStrokeColor(UIColor(red: 227.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 255.0, alpha: 1).cgColor);
            context.beginPath();
            
            context.setLineDash(phase: 10.0, lengths: [5,3]);
            context.move(to: CGPoint(x: 0, y:  self.frame.height / 2.0));
            context.addLine(to: CGPoint(x: Double(self.frame.width), y: Double(self.frame.height) / 2.0));
            
            context.strokePath();
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
            startPoint = touch.location(in: self);
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch:AnyObject in touches{
            let movePoint:CGPoint = touch.location(in: self);
            let offsetY = movePoint.y - startPoint.y;
            self.center = CGPoint(x: self.center.x, y: self.center.y + offsetY);
            
            if self.frame.origin.y < 0 {
                self.frame.origin.y = 0;
            }
            if self.frame.origin.y + self.frame.size.height > screenObject.height - 64.0 {
                self.frame.origin.y = screenObject.height - 64 - self.frame.size.height;
            }
            
            if self.MoveBlock != nil {
                self.MoveBlock!();
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
