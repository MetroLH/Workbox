//
//  CompassCenterView.swift
//  Workbox
//
//  Created by 刘海 on 2017/1/6.
//  Copyright © 2017年 刘海. All rights reserved.
//

import UIKit

class CompassCenterView: MainUIView {

    var radius:     CGFloat!;
    var point:      CGPoint!;
    
    init(frame :CGRect,radius: CGFloat){
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
        
        self.radius = radius * 0.2;
        point = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0);
        
        drawDial();
        
    }
    
    func drawDial(){
        
        let bezPath = UIBezierPath(arcCenter:self.point
            , radius: radius
            , startAngle: -CGFloat(M_PI_2)
            , endAngle: CGFloat(M_PI_2 * 3)
            , clockwise: true);
        
        bezPath.move(to: CGPoint(x: frame.width / 2.0 - radius / 4.0, y: frame.height / 2.0));
        bezPath.addLine(to: CGPoint(x: frame.width / 2.0 + radius / 4.0, y: frame.height / 2.0));
        
        bezPath.move(to: CGPoint(x: frame.width / 2.0, y: frame.height / 2.0 - radius / 4.0));
        bezPath.addLine(to: CGPoint(x: frame.width / 2.0, y: frame.height / 2.0 + radius / 4.0));
        
        let shapeLayer = CAShapeLayer();
        shapeLayer.lineWidth = 1;
        shapeLayer.fillColor = Color(red: 63, green: 226, blue: 137, alpha: 0.7).cgColor;
        shapeLayer.strokeColor = Color(red: 22, green: 22, blue: 22, alpha: 0.5).cgColor;
        shapeLayer.path = bezPath.cgPath;
        self.layer .addSublayer(shapeLayer);
        
        
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
