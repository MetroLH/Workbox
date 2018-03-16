//
//  RulerControlView.swift
//  Workbox
//
//  Created by 刘海 on 2016/12/30.
//  Copyright © 2016年 刘海. All rights reserved.
//

import UIKit

class RulerControlView: MainUIView {
    
    var cmLabel:UILabel!;
    var inchLabel:UILabel!;
    var rulerv1:RulerVernierView!;
    var rulerv2:RulerVernierView!;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.clear;
        
        cmLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenObject.height-64.0, height: 40.0));
        cmLabel.backgroundColor = UIColor.clear;
        cmLabel.text = "0.00 cm";
        cmLabel.textAlignment = .center;
        cmLabel.font = UIFont.systemFont(ofSize: 28);
        cmLabel.textColor = UIColor(red: 227.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 255.0, alpha: 1);
        cmLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
        
        cmLabel.frame.origin.x = screenObject.width - 85;
        cmLabel.frame.origin.y = 0;
        self.addSubview(cmLabel);
        
        inchLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenObject.height-64.0, height: 40.0));
        inchLabel.backgroundColor = UIColor.clear;
        inchLabel.text = "0.00 inch";
        inchLabel.textAlignment = .center;
        inchLabel.font = UIFont.systemFont(ofSize: 28);
        inchLabel.textColor = UIColor(red: 227.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 255.0, alpha: 1);
        inchLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
        
        inchLabel.frame.origin.x = 45;
        inchLabel.frame.origin.y = 0;
        self.addSubview(inchLabel);
        

        
        rulerv1 = RulerVernierView(frame: CGRect(x: 0, y: 0, width: screenObject.width, height: 20.0));
        rulerv1.MoveBlock = {
            let ybSpace:Double = fabs(Double(self.rulerv2.frame.origin.y - self.rulerv1.frame.origin.y));
            self.cmLabel.text = String(format: "%.2f", floorToPlaces(value: ybSpace / Double(lineCMSpacing) / 10.0, places: 2)) + " cm";
            self.inchLabel.text = String(format: "%.2f", floorToPlaces(value: ybSpace / Double(lineINCHSpacing) / 10.0, places: 2)) + " inch";
        }
        self.addSubview(rulerv1);
        
        rulerv2 = RulerVernierView(frame: CGRect(x: 0, y: (screenObject.height - 20.0) / 2.0, width: screenObject.width, height: 20.0));
        rulerv2.MoveBlock = {
            let ybSpace:Double = fabs(Double(self.rulerv2.frame.origin.y - self.rulerv1.frame.origin.y));
            self.cmLabel.text = String(format: "%.2f", floorToPlaces(value: ybSpace / Double(lineCMSpacing) / 10.0, places: 2)) + " cm";
            self.inchLabel.text = String(format: "%.2f", floorToPlaces(value: ybSpace / Double(lineINCHSpacing) / 10.0, places: 2)) + " inch";
        }
        self.addSubview(rulerv2);
        
        //初始化默认距离
        //像素数
        let ybSpace:Double = fabs(Double(rulerv2.frame.origin.y - rulerv1.frame.origin.y));
        cmLabel.text = String(format: "%.2f", floorToPlaces(value: ybSpace / Double(lineCMSpacing) / 10.0, places: 2)) + " cm";
        inchLabel.text = String(format: "%.2f", floorToPlaces(value: ybSpace / Double(lineINCHSpacing) / 10.0, places: 2)) + " inch";
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
