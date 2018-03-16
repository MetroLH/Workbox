//
//  DecibelBackgroundView.swift
//  Workbox
//
//  Created by 刘海 on 2017/1/5.
//  Copyright © 2017年 刘海. All rights reserved.
//

import UIKit

class DecibelBackgroundView: MainUIView {
    var radius:CGFloat!;
    
    override init(frame :CGRect){
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
        
        radius = (frame.size.width - 2.0) / 2.0;
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
            context.beginPath();
            context.setStrokeColor(Color(red: 63, green: 226, blue: 137, alpha: 1).cgColor);
            context.setFillColor(Color(red: 63, green: 226, blue: 137, alpha: 1).cgColor);
            context.move(to: CGPoint(x: self.frame.width / 2.0, y: self.frame.height - 30));
            
            context.addArc(center: CGPoint(x:self.frame.width / 2.0 ,y: self.frame.height - 30),
                           radius: radius,
                           startAngle: AngleToRadian(angle:180.0) + CGFloat.pi,
                           endAngle: AngleToRadian(angle: 0.0 ) + CGFloat.pi,
                           clockwise: true);
            
            context.closePath();
            context.drawPath(using: CGPathDrawingMode.fillStroke);
            
            //画扇形
//            context.beginPath();
//            context.setStrokeColor(Color(red: 255, green: 104, blue: 107, alpha: 1).cgColor);
//            context.setFillColor(Color(red: 255, green: 104, blue: 107, alpha: 1).cgColor);
//            context.move(to: CGPoint(x: self.frame.width / 2.0, y: self.frame.height - 30));
//            
//            context.addArc(center: CGPoint(x:self.frame.width / 2.0 ,y: self.frame.height - 30),
//                           radius: radius / 9.0,
//                           startAngle: AngleToRadian(angle:180.0) + CGFloat(M_PI),
//                           endAngle: AngleToRadian(angle: 0.0 ) + CGFloat(M_PI),
//                           clockwise: true);
//            
//            context.closePath();
//            context.drawPath(using: CGPathDrawingMode.fillStroke);
            
            
            //角度线
            context.beginPath();
            var angle = 0;
            
            while angle <= 150 {
                
                if angle < 61 {
                     context.setStrokeColor(Color(red: 255, green: 104, blue: 107, alpha: 1).cgColor);
                }else{
                     context.setStrokeColor(UIColor.white.cgColor);
                }
                
                let dbAngle = CGFloat(angle) * (180.0 / 150.0);
                
                var startx:CGFloat = self.frame.width / 2.0 + cos(AngleToRadian(angle: CGFloat(dbAngle)) ) * (radius - 15.0);
                var starty:CGFloat = self.frame.height - 30 - sin(AngleToRadian(angle: CGFloat(dbAngle)) ) * (radius - 15.0);
                
                if angle % 5 == 0 && angle % 10 != 0 {
                    startx = self.frame.width / 2.0 + cos(AngleToRadian(angle: CGFloat(dbAngle)) ) * (radius - 22.0);
                    starty = self.frame.height - 30 - sin(AngleToRadian(angle: CGFloat(dbAngle)) ) * (radius - 22.0);
                }else if angle % 10 == 0 {
                    startx = self.frame.width / 2.0 + cos(AngleToRadian(angle: CGFloat(dbAngle)) ) * (radius - 30.0);
                    starty = self.frame.height - 30 - sin(AngleToRadian(angle: CGFloat(dbAngle)) ) * (radius - 30.0);
                    
                    let labelx:CGFloat = self.frame.width / 2.0 + cos(AngleToRadian(angle: CGFloat(dbAngle)) ) * (radius - 40.0);
                    let labely:CGFloat = self.frame.height - 30 - sin(AngleToRadian(angle: CGFloat(dbAngle)) ) * (radius - 40.0);
                    
                    let rect:CGRect = CGRect(x: 0,
                                             y: 0,
                                             width: 30.0,
                                             height: 12.0);
                    
                    let indexLabel:UILabel = UILabel(frame: rect);
                    indexLabel.backgroundColor = UIColor.clear;
                    indexLabel.text = String(stringInterpolationSegment: 150 - angle);
                    indexLabel.textAlignment = .center;
                    indexLabel.font = UIFont.systemFont(ofSize: 12);
                    
                    if angle < 70 {
                        indexLabel.textColor = Color(red: 255, green: 104, blue: 107, alpha: 1);
                    }else{
                        indexLabel.textColor = UIColor.white
                    }
                    if angle != 0 && angle != 150 {
                        
                        indexLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2) - AngleToRadian(angle: CGFloat(dbAngle)));
                        indexLabel.center = CGPoint(x: labelx, y: labely);
                    }else{
                        
                        indexLabel.center = CGPoint(x: labelx, y: labely - 6);
                    }
                    self.addSubview(indexLabel);
                }
                
                let endx:CGFloat = self.frame.width / 2.0 + cos(AngleToRadian(angle: CGFloat(dbAngle)) ) * radius;
                let endy:CGFloat = self.frame.height - 30 - sin(AngleToRadian(angle: CGFloat(dbAngle))) * radius;
                
                context.move(to: CGPoint(x: startx, y: starty));
                context.addLine(to: CGPoint(x: endx, y: endy));
                
                angle += 1;
                
                context.strokePath();

            }
            
            
            
            context.beginPath();
            
            context.setStrokeColor(Color(red: 255, green: 104, blue: 107, alpha: 1).cgColor);
            context.addArc(center: CGPoint(x: self.frame.width / 2.0 ,y: self.frame.size.height - 30), radius: radius, startAngle: 0, endAngle: AngleToRadian(angle: -60.01 * (180.0 / 150.0)), clockwise: true);
            
            context.strokePath();
            
            //最小填充区域
            context.setStrokeColor(UIColor.white.cgColor);
            
            context.addArc(center: CGPoint(x: self.frame.width / 2.0 ,y: self.frame.size.height - 30), radius: radius / 3.0, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true);
            
            context.move(to: CGPoint(x: 1, y:  self.frame.height - 30));
            context.addLine(to: CGPoint(x: self.frame.width - 1, y: self.frame.height - 30));
            
            context.strokePath();
        }
    }

}
