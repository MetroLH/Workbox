//
//  GradienterFrontgroundView.swift
//  Workbox
//
//  Created by 刘海 on 2017/1/4.
//  Copyright © 2017年 刘海. All rights reserved.
//

import UIKit

class GradienterFrontgroundView: MainUIView {

    override init(frame : CGRect){
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext(){
            context.setLineCap(CGLineCap.round);
            context.setLineWidth(1);
            context.setAllowsAntialiasing(true);
            
            context.beginPath();
            context.setStrokeColor(Color(red: 0, green: 104, blue: 58, alpha: 1.0).cgColor);
            context.addArc(center: CGPoint(x:self.frame.width / 2.0 ,y: self.frame.height / 2.0),
                           radius: (self.frame.width - 144.0) / 2.0,
                           startAngle: 0.0,
                           endAngle: CGFloat(M_PI * 2.0),
                           clockwise: false);
            
            context.addArc(center: CGPoint(x:self.frame.width / 2.0 ,y: self.frame.height / 2.0),
                          radius: ((self.frame.width - 144.0) / 2.0) / 3.0,
                          startAngle: 0.0,
                          endAngle: CGFloat(M_PI * 2.0),
                          clockwise: false);
            
            context.addArc(center: CGPoint(x:self.frame.width / 2.0 ,y: self.frame.height / 2.0),
                           radius: ((self.frame.width - 144.0) / 2.0) / 3.0 * 2.0,
                           startAngle: 0.0,
                           endAngle: CGFloat(M_PI * 2.0),
                           clockwise: false);
            
            context.move(to: CGPoint(x: 72.0, y:  self.frame.height / 2.0));
            context.addLine(to: CGPoint(x: 72.0 + (self.frame.width - 144.0), y: self.frame.height / 2.0));
            
            context.move(to: CGPoint(x: self.frame.width / 2.0, y:  (self.frame.height - (self.frame.width - 144.0)) / 2.0));
            context.addLine(to: CGPoint(x: self.frame.width / 2.0, y: (self.frame.height - (self.frame.width - 144.0)) / 2.0 + (self.frame.width - 144.0)));
            
            context.move(to: CGPoint(x: self.frame.width / 2.0 - 15, y: (self.frame.height - (self.frame.width - 144.0)) / 2.0 + (self.frame.width - 144.0) + 15.0));
            context.addLine(to: CGPoint(x: self.frame.width / 2.0 - 15, y: (self.frame.height - (self.frame.width - 144.0)) / 2.0 + (self.frame.width - 144.0) + 15.0 + 30.0));
            
            context.move(to: CGPoint(x: self.frame.width / 2.0 + 15, y: (self.frame.height - (self.frame.width - 144.0)) / 2.0 + (self.frame.width - 144.0) + 15.0));
            context.addLine(to: CGPoint(x: self.frame.width / 2.0 + 15, y: (self.frame.height - (self.frame.width - 144.0)) / 2.0 + (self.frame.width - 144.0) + 15.0 + 30.0));
            
            
            context.move(to: CGPoint(x: 72.0 - 45.0, y: self.frame.height / 2.0 - 15.0));
            context.addLine(to: CGPoint(x: 72.0 - 15.0, y: self.frame.height / 2.0 - 15.0));
            
            context.move(to: CGPoint(x: 72.0 - 45.0, y: self.frame.height / 2.0 + 15.0));
            context.addLine(to: CGPoint(x: 72.0 - 15.0 , y: self.frame.height / 2.0 + 15.0));
            
            context.strokePath();
            
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
