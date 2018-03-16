//
//  CompassBackgroundView.swift
//  Workbox
//
//  Created by 刘海 on 2017/1/6.
//  Copyright © 2017年 刘海. All rights reserved.
//

import UIKit

class CompassBackgroundView: MainUIView {
    
    var radius:     CGFloat!;
    var point:      CGPoint!;
    
    init(frame :CGRect,radius: CGFloat){
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
        
        self.radius = radius;
        point = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0);
        
        drawDial();
        
    }
    
    //绘制表盘
    func drawDial(){
        
        let bezPath = UIBezierPath(arcCenter:self.point
            , radius: radius
            , startAngle: -CGFloat(M_PI_2)
            , endAngle: CGFloat(M_PI_2 * 3)
            , clockwise: true);
        
        let shapeLayer = CAShapeLayer();
        shapeLayer.lineWidth = 1;
        shapeLayer.fillColor = UIColor.clear.cgColor;
        shapeLayer.strokeColor = UIColor.white.cgColor;
        shapeLayer.path = bezPath.cgPath;
        self.layer .addSublayer(shapeLayer);
        
        let perAngle:CGFloat = CGFloat(M_PI) / 90.0;
        let array = [NSLocalizedString("bei", comment: ""),
                     NSLocalizedString("dong", comment: ""),
                     NSLocalizedString("nan", comment: ""),
                     NSLocalizedString("xi", comment: "")];
        
        for i in 0..<180 {
            let startAngle = (-CGFloat(M_PI_2) + perAngle * CGFloat(i));
            let endAngle = startAngle + perAngle / 2.0;
            
            let tbezPath = UIBezierPath(arcCenter:self.point
                , radius: radius * 0.9
                , startAngle: startAngle
                , endAngle: endAngle
                , clockwise: true);
            
            let tshapeLayer = CAShapeLayer();
            if i == 0 {
                tshapeLayer.strokeColor =  UIColor(red: 227.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 255.0, alpha: 1).cgColor;
                tshapeLayer.lineWidth = 16;
            }else if i % 15 == 0{
                tshapeLayer.strokeColor =  UIColor.white.cgColor;
                tshapeLayer.lineWidth = 16;
            }else {
                tshapeLayer.strokeColor =  Color(red: 255, green: 255, blue: 255, alpha: 0.6).cgColor;
                tshapeLayer.lineWidth = 8;
            }
            
            tshapeLayer.path = tbezPath.cgPath;
            tshapeLayer.fillColor = UIColor.clear.cgColor;
            self.layer.addSublayer(tshapeLayer);
            
            if i % 15 == 0 {
                var tick = String(format: "%d", i * 2);
                
                if i % 45 == 0 {
                    tick = array[i / 45];
                }
                
                if i < 180 {
                    let textAngle = startAngle + (endAngle - startAngle) / 2;
                    let textPoint = calculateTextPositonWithArcCenter(center:self.point
                        , angle:textAngle);
                    
                    let label = UILabel(frame: CGRect(x: textPoint.x, y: textPoint.y, width: 30, height: 30));
                    label.center = textPoint;
                    label.text = tick;
                    
                    if i == 0 {
                        label.textColor = UIColor(red: 227.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 255.0, alpha: 1);
                    }else{
                        label.textColor = UIColor.white;
                    }
                    if i % 45 == 0 {
                        label.font = UIFont.boldSystemFont(ofSize: 16.0);
                    }else{
                        label.font = UIFont.systemFont(ofSize: 14);
                    }
                    
                    label.textAlignment = NSTextAlignment.center;
                    label.transform = CGAffineTransform(rotationAngle: CGFloat(AngleToRadian(angle: CGFloat(i) * 2.0)));
                    
                    self.addSubview(label);
                }
            }
        }
    }
    
    //计算中心坐标
    func calculateTextPositonWithArcCenter(center: CGPoint,angle :CGFloat) -> CGPoint{
        let x = self.radius * 0.75 * CGFloat(cos(Double(angle)));
        let y = self.radius * 0.75 * CGFloat(sin(Double(angle)));
        
        return CGPoint(x: center.x + x, y: center.y + y);
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

}
