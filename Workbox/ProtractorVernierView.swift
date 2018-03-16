//
//  ProtractorVernierView.swift
//  Workbox
//  角度游标
//  Created by 刘海 on 2016/12/31.
//  Copyright © 2016年 刘海. All rights reserved.
//

import UIKit

class ProtractorVernierView: MainUIView {
    
    var radius:         CGFloat!;
    var defaultAngle1:  CGFloat!;
    var defaultAngle2:  CGFloat!;
    var iconImage1:     ProtractorNoniusView!;
    var iconImage2:     ProtractorNoniusView!;
    
    var angleLabel:UILabel!;
    
    //声明一个属性Block，type为闭包可选类型
    //闭包类型：(UIView)->(UIView) ，参数是本身View，返回本身View
    var MoveBlock:(()->Swift.Void)?;
    
    override init(frame : CGRect){
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.clear;
        
        radius = (frame.size.height - 80.0) / 2.0 - 10.0;
        defaultAngle1 = 80;
        defaultAngle2 = 100;
        
        let image1x:CGFloat = cos(CGFloat(M_PI) - AngleToRadian(angle: CGFloat(defaultAngle1)) + CGFloat(M_PI + M_PI_2)) * (radius / 2.0);
        let image1y:CGFloat = self.frame.height / 2.0 - sin(CGFloat(M_PI) - AngleToRadian(angle: CGFloat(defaultAngle1)) + CGFloat(M_PI + M_PI_2)) * (radius / 2.0);
        
        iconImage1 = ProtractorNoniusView(frame: CGRect(x: 0, y: 0, width: 30, height: 30));
        self.addSubview(iconImage1);
        iconImage1.center = CGPoint(x: image1x, y: image1y);
        iconImage1.MoveBlock = {
            //重新画线的角度

            let x1 = 0;
            let y1 = self.frame.height / 2.0;
            
            let x2 = self.iconImage1.center.x;
            let y2 = self.iconImage1.center.y;
            
            let radian = atan((Double(x2)-Double(x1))/(Double(y2) - Double(y1)));
            if radian < 0 {
                self.defaultAngle1 = RadianToAngle(angle: CGFloat(fabs(radian)));
            }else{
                self.defaultAngle1 = 180.0 - RadianToAngle(angle: CGFloat(radian));
            }
            
            if self.defaultAngle1 < 1.0 {
                self.defaultAngle1 = 0;
            }
            if self.defaultAngle1 > 179.0 {
                self.defaultAngle1 = 180.0;
            }
            
            let includedAngle = fabs(180.0 - self.defaultAngle1 - (180.0 - self.defaultAngle2));
            if (self.angleLabel != nil) {
                let angleString = String(format: "%.1f", floorToPlaces(value: Double(includedAngle), places: 1)) + "°"
                let radianString = String(format: "%.1f", AngleToRadian(angle: includedAngle)) + "rad";
                self.angleLabel.text = angleString + " " + radianString;
            }
            self.setNeedsDisplay();
        }
        
        
        let image2x:CGFloat = cos(CGFloat(M_PI) - AngleToRadian(angle: CGFloat(defaultAngle2)) + CGFloat(M_PI + M_PI_2)) * (radius / 2.0);
        let image2y:CGFloat = self.frame.height / 2.0 - sin(CGFloat(M_PI) - AngleToRadian(angle: CGFloat(defaultAngle2)) + CGFloat(M_PI + M_PI_2)) * (radius / 2.0);
        
        iconImage2 = ProtractorNoniusView(frame: CGRect(x: 0, y: 0, width: 30, height: 30));
        self.addSubview(iconImage2);
        iconImage2.center = CGPoint(x: image2x, y: image2y);
        iconImage2.MoveBlock = {
            //重新画线的角度
            let x1 = 0;
            let y1 = self.frame.height / 2.0;
            
            let x2 = self.iconImage2.center.x;
            let y2 = self.iconImage2.center.y;
            
            let radian = atan((Double(x2)-Double(x1))/(Double(y2) - Double(y1)));
            if radian < 0 {
                self.defaultAngle2 = RadianToAngle(angle: CGFloat(fabs(radian)));
            }else{
                self.defaultAngle2 = 180.0 - RadianToAngle(angle: CGFloat(radian));
            }
            if self.defaultAngle2 < 1.0 {
                self.defaultAngle2 = 0;
            }
            if self.defaultAngle2 > 179.0 {
                self.defaultAngle2 = 180.0;
            }
            
            let includedAngle = fabs(180.0 - self.defaultAngle1 - (180.0 - self.defaultAngle2));
            if (self.angleLabel != nil) {
                let angleString = String(format: "%.1f", floorToPlaces(value: Double(includedAngle), places: 1)) + "°"
                let radianString = String(format: "%.1f", AngleToRadian(angle: includedAngle)) + "rad";
                self.angleLabel.text = angleString + " " + radianString;
            }
            
            self.setNeedsDisplay();
        }
        
        angleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenObject.height-64.0, height: 40.0));
        angleLabel.backgroundColor = UIColor.clear;
        angleLabel.text = "20.0°  0.3rad";
        angleLabel.textAlignment = .center;
        angleLabel.font = UIFont.systemFont(ofSize: 28);
        angleLabel.textColor = UIColor(red: 227.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 255.0, alpha: 1);
        angleLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
        
        angleLabel.frame.origin.x = screenObject.width - 100;
        angleLabel.frame.origin.y = 0;
        self.addSubview(angleLabel);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext(){
            context.setLineCap(CGLineCap.round);
            context.setLineWidth(1);
            context.setAllowsAntialiasing(true);
                        
            //画扇形
            context.setStrokeColor(UIColor(red: 227.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 255.0, alpha: 0.2).cgColor);
            context.beginPath();
            
            context.setFillColor(UIColor(red: 227.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 255.0, alpha: 0.2).cgColor);
            context.move(to: CGPoint(x: 0, y: self.frame.height / 2.0));
            if self.defaultAngle1 < self.defaultAngle2 {
                context.addArc(center: CGPoint(x:0 ,y: self.frame.height / 2.0),
                               radius: radius + 10.0,
                               startAngle: AngleToRadian(angle:self.defaultAngle2) + CGFloat(M_PI + M_PI_2),
                               endAngle: AngleToRadian(angle: self.defaultAngle1) + CGFloat(M_PI + M_PI_2),
                               clockwise: true);
            }else{
                context.addArc(center: CGPoint(x:0 ,y: self.frame.height / 2.0),
                               radius: radius + 10.0,
                               startAngle: AngleToRadian(angle:self.defaultAngle1) + CGFloat(M_PI + M_PI_2),
                               endAngle: AngleToRadian(angle: self.defaultAngle2) + CGFloat(M_PI + M_PI_2),
                               clockwise: true);
            }

            context.closePath();
            context.drawPath(using: CGPathDrawingMode.fillStroke);
            
            
            //画虚线
            
            context.setStrokeColor(UIColor(red: 227.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 255.0, alpha: 1).cgColor);
            context.beginPath();
            context.setLineDash(phase: 10.0, lengths: [5,3]);
            //第一条线
            let end1x:CGFloat = cos(CGFloat(M_PI) - AngleToRadian(angle: CGFloat(defaultAngle1)) + CGFloat(M_PI + M_PI_2)) * self.frame.height;
            let end1y:CGFloat = self.frame.height / 2.0 - sin(CGFloat(M_PI) - AngleToRadian(angle: CGFloat(defaultAngle1)) + CGFloat(M_PI + M_PI_2)) * self.frame.height;
            
            context.move(to: CGPoint(x: 0, y:  self.frame.height / 2.0));
            context.addLine(to: CGPoint(x: end1x, y: end1y));
            
            //第二条线
            let end2x:CGFloat = cos(CGFloat(M_PI) - AngleToRadian(angle: CGFloat(defaultAngle2)) + CGFloat(M_PI + M_PI_2)) * self.frame.height;
            let end2y:CGFloat = self.frame.height / 2.0 - sin(CGFloat(M_PI) - AngleToRadian(angle: CGFloat(defaultAngle2)) + CGFloat(M_PI + M_PI_2)) * self.frame.height;
            
            context.move(to: CGPoint(x: 0, y:  self.frame.height / 2.0));
            context.addLine(to: CGPoint(x: end2x, y: end2y));
            
            context.strokePath();
        }
    }
}
