//
//  ProtractorBackgroundView.swift
//  Workbox
//  量角器刻度渲染层
//  Created by 刘海 on 2016/12/30.
//  Copyright © 2016年 刘海. All rights reserved.
//

import UIKit

class ProtractorBackgroundView: MainUIView {
    
    var radius:CGFloat!;
    
    override init(frame :CGRect){
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
        
        radius = (frame.size.height - 80.0) / 2.0 - 10.0;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext(){
            context.setLineCap(CGLineCap.round);
            context.setLineWidth(1);
            context.setAllowsAntialiasing(true);
            
            //画扇形
            context.beginPath();
            context.setStrokeColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3).cgColor);
            context.setFillColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3).cgColor);
            context.move(to: CGPoint(x: 0, y: self.frame.height / 2.0));
            
            context.addArc(center: CGPoint(x:0 ,y: self.frame.height / 2.0),
                           radius: radius + 10.0,
                           startAngle: AngleToRadian(angle:180.0) + CGFloat(M_PI + M_PI_2),
                           endAngle: AngleToRadian(angle: 0.0 ) + CGFloat(M_PI + M_PI_2),
                           clockwise: true);
            
            context.closePath();
            context.drawPath(using: CGPathDrawingMode.fillStroke);
            
            
            //角度线
            context.beginPath();
            context.setStrokeColor(UIColor(red: 22.0 / 255.0, green: 22.0 / 255.0, blue: 22.0 / 255.0, alpha: 1).cgColor);
            
            var angle = 0;
            
            while angle<=180 {
                
                var startx:CGFloat = cos(AngleToRadian(angle: CGFloat(angle)) + CGFloat(M_PI + M_PI_2)) * (radius - 15.0);
                var starty:CGFloat = self.frame.height / 2.0 - sin(AngleToRadian(angle: CGFloat(angle)) + CGFloat(M_PI + M_PI_2)) * (radius - 15.0);
                
                if angle % 5 == 0 && angle % 10 != 0 {
                    startx = cos(AngleToRadian(angle: CGFloat(angle)) + CGFloat(M_PI + M_PI_2)) * (radius - 22.0);
                    starty = self.frame.height / 2.0 - sin(AngleToRadian(angle: CGFloat(angle)) + CGFloat(M_PI + M_PI_2)) * (radius - 22.0);
                }else if angle % 10 == 0 {
                    startx = cos(AngleToRadian(angle: CGFloat(angle)) + CGFloat(M_PI + M_PI_2)) * (radius - 30.0);
                    starty = self.frame.height / 2.0 - sin(AngleToRadian(angle: CGFloat(angle)) + CGFloat(M_PI + M_PI_2)) * (radius - 30.0);
                    
                    let labelx:CGFloat = cos(AngleToRadian(angle: CGFloat(angle)) + CGFloat(M_PI + M_PI_2)) * (radius - 38.0);
                    let labely:CGFloat = self.frame.height / 2.0 - sin(AngleToRadian(angle: CGFloat(angle)) + CGFloat(M_PI + M_PI_2)) * (radius - 38.0);
                    
                    let rect:CGRect = CGRect(x: 0,
                                             y: 0,
                                             width: 30.0,
                                             height: 12.0);
                    
                    let indexLabel:UILabel = UILabel(frame: rect);
                    indexLabel.backgroundColor = UIColor.clear;
                    indexLabel.text = String(180 - angle);
                    indexLabel.textAlignment = .center;
                    indexLabel.font = UIFont.systemFont(ofSize: 12);
                    indexLabel.textColor = UIColor(red: 22.0 / 255.0, green: 22.0 / 255.0, blue: 22.0 / 255.0, alpha: 1);
                    if angle != 0 && angle != 180 {

                        indexLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI) - AngleToRadian(angle: CGFloat(angle)));
                        indexLabel.center = CGPoint(x: labelx, y: labely);
                    }else{

                        indexLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
                        indexLabel.center = CGPoint(x: labelx + 6, y: labely);
                    }
                    self.addSubview(indexLabel);
                    
                    //拖动区域内画线
                    let starttempx:CGFloat = cos(AngleToRadian(angle: CGFloat(angle)) + CGFloat(M_PI + M_PI_2)) * (radius / 2.0 - 20.0);
                    let starttempy:CGFloat = self.frame.height / 2.0 - sin(AngleToRadian(angle: CGFloat(angle)) + CGFloat(M_PI + M_PI_2)) * (radius / 2.0 - 20.0);
                    
                    let endtempx:CGFloat = cos(AngleToRadian(angle: CGFloat(angle)) + CGFloat(M_PI + M_PI_2)) * (radius / 2.0 - 3.0);
                    let endtempy:CGFloat = self.frame.height / 2.0 - sin(AngleToRadian(angle: CGFloat(angle)) + CGFloat(M_PI + M_PI_2)) * (radius / 2.0 - 3.0);
                    
                    context.move(to: CGPoint(x: starttempx, y: starttempy));
                    context.addLine(to: CGPoint(x: endtempx, y: endtempy));
                }
                
                let endx:CGFloat = cos(AngleToRadian(angle: CGFloat(angle)) + CGFloat(M_PI + M_PI_2)) * radius;
                let endy:CGFloat = self.frame.height / 2.0 - sin(AngleToRadian(angle: CGFloat(angle)) + CGFloat(M_PI + M_PI_2)) * radius;
                
                context.move(to: CGPoint(x: startx, y: starty));
                context.addLine(to: CGPoint(x: endx, y: endy));
                
                angle += 1;
            }
            
            context.strokePath();
            
            
            context.setStrokeColor(UIColor(red: 160.0 / 255.0, green: 160.0 / 255.0, blue: 160.0 / 255.0, alpha: 1).cgColor);
            context.beginPath();
            
            context.addArc(center: CGPoint(x: 0.0,y: self.frame.size.height / 2.0), radius: radius + 10.0, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI + M_PI_2), clockwise: true);
            
            context.addArc(center: CGPoint(x: 0.0,y: self.frame.size.height / 2.0), radius: radius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI + M_PI_2), clockwise: true);
            
            //拖动区域
            context.addArc(center: CGPoint(x: 0.0,y: self.frame.size.height / 2.0), radius: radius / 2.0 + 3.0, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI + M_PI_2), clockwise: true);
            
            context.addArc(center: CGPoint(x: 0.0,y: self.frame.size.height / 2.0), radius: radius / 2.0 - 3.0, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI + M_PI_2), clockwise: true);
            
            //最小填充区域
            context.addArc(center: CGPoint(x: 0.0,y: self.frame.size.height / 2.0), radius: radius / 8.0, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI + M_PI_2), clockwise: true);
            
            context.move(to: CGPoint(x: 0, y:  40));
            context.addLine(to: CGPoint(x: 0, y: self.frame.height - 40));
            
            context.strokePath();
        }
    }

}
