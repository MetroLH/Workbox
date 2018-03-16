//
//  CompassFrontgroundView.swift
//  Workbox
//
//  Created by 刘海 on 2017/1/6.
//  Copyright © 2017年 刘海. All rights reserved.
//

import UIKit

class CompassFrontgroundView: MainUIView {

    var radius:     CGFloat!;
    var point:      CGPoint!;
    
    init(frame :CGRect,radius: CGFloat){
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
        
        self.radius = radius;
        point = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0);
        
        drawDial();
        
    }
    
    func drawDial(){
        
        let bezPath = UIBezierPath(arcCenter:self.point
            , radius: radius / 3.0
            , startAngle: -CGFloat(M_PI_2)
            , endAngle: CGFloat(M_PI_2 * 3)
            , clockwise: true);
        
        bezPath.move(to: CGPoint(x: frame.width / 2.0 - radius / 2.0, y: frame.height / 2.0));
        bezPath.addLine(to: CGPoint(x: frame.width / 2.0 + radius / 2.0, y: frame.height / 2.0));
        
        bezPath.move(to: CGPoint(x: frame.width / 2.0, y: frame.height / 2.0 - radius / 2.0));
        bezPath.addLine(to: CGPoint(x: frame.width / 2.0, y: frame.height / 2.0 + radius / 2.0));
        
        let shapeLayer = CAShapeLayer();
        shapeLayer.lineWidth = 1;
        shapeLayer.fillColor = UIColor.clear.cgColor;
        shapeLayer.strokeColor = UIColor.white.cgColor;
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
