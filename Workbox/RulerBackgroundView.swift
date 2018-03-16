//
//  RulerBackgroundView.swift
//  Workbox
//
//  Created by 刘海 on 2016/12/27.
//  Copyright © 2016年 刘海. All rights reserved.
//

import UIKit

class RulerBackgroundView: MainUIView {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func draw(_ rect: CGRect) {
        
        //158.1mm
        //736.0像素
        //每4.65画一条线
        //1 inch = 25.4mm  118.11像素是1 inch 11.811像素画一条线
        print("width=",screenObject.width,"height=",screenObject.height)

        if let context = UIGraphicsGetCurrentContext(){
            context.setLineCap(CGLineCap.round);
            context.setLineWidth(1);
            context.setAllowsAntialiasing(true);
            context.setStrokeColor(UIColor(red: 22.0 / 255.0, green: 22.0 / 255.0, blue: 22.0 / 255.0, alpha: 1).cgColor);
            context.beginPath();
            
            var lineIndex:Int = 0;
            
            //标线 cm
            while CGFloat(lineCMSpacing * Double(lineIndex)) < screenObject.height {
                
                context.move(to: CGPoint(x: Double(screenObject.width), y: Double(lineIndex) * lineCMSpacing));
                if lineIndex % 5 == 0 && lineIndex % 10 != 0{
                    context.addLine(to: CGPoint(x: Double(screenObject.width - 22), y: Double(lineIndex) * lineCMSpacing));
                }else if lineIndex % 10 == 0{
                    context.addLine(to: CGPoint(x: Double(screenObject.width - 30), y: Double(lineIndex) * lineCMSpacing));

                    
                    //厘米标记
                    var rect:CGRect = CGRect(x: Double(screenObject.width - 45),
                                             y: Double(lineIndex) * lineCMSpacing,
                                             width: 16.0,
                                             height: 12.0);
                    if lineIndex != 0 {
                        rect = CGRect(x: Double(screenObject.width - 45),
                                     y: Double(lineIndex) * lineCMSpacing - 5.5,
                                     width: 16.0,
                                     height: 12.0);
                    }
                    let indexLabel:UILabel = UILabel(frame: rect);
                    indexLabel.backgroundColor = UIColor.clear;
                    indexLabel.text = String(stringInterpolationSegment:lineIndex/10);
                    indexLabel.textAlignment = .center;
                    indexLabel.font = UIFont.systemFont(ofSize: 12);
                    indexLabel.textColor = UIColor(red: 22.0 / 255.0, green: 22.0 / 255.0, blue: 22.0 / 255.0, alpha: 1);
                    indexLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
                    self.addSubview(indexLabel);
                    
                }else{
                    context.addLine(to: CGPoint(x: Double(screenObject.width - 15), y: Double(lineIndex) * lineCMSpacing));
                }
                lineIndex += 1;
                
            }
            
            var lineINCHIndex:Int = 0;
            
            //标线 inch
            while CGFloat(lineINCHSpacing * Double(lineINCHIndex)) < screenObject.height {
                
                context.move(to: CGPoint(x: 0, y:  Double(lineINCHIndex) * lineINCHSpacing));
                if lineINCHIndex % 5 == 0 && lineINCHIndex % 10 != 0{
                    context.addLine(to: CGPoint(x: 22, y: Double(lineINCHIndex) * lineINCHSpacing));
                }else if lineINCHIndex % 10 == 0{
                    context.addLine(to: CGPoint(x: 30, y: Double(lineINCHIndex) * lineINCHSpacing));
                    
                    //厘米标记
                    var rect:CGRect = CGRect(x: 30.0,
                                             y: Double(lineINCHIndex) * lineINCHSpacing,
                                             width: 16.0,
                                             height: 12.0);
                    if lineINCHIndex != 0 {
                        rect = CGRect(x: 30.0,
                                      y: Double(lineINCHIndex) * lineINCHSpacing - 5.5,
                                      width: 16.0,
                                      height: 12.0);
                    }
                    let indexLabel:UILabel = UILabel(frame: rect);
                    indexLabel.backgroundColor = UIColor.clear;
                    indexLabel.text = String(stringInterpolationSegment:lineINCHIndex/10);
                    indexLabel.textAlignment = .center;
                    indexLabel.font = UIFont.systemFont(ofSize: 12);
                    indexLabel.textColor = UIColor(red: 22.0 / 255.0, green: 22.0 / 255.0, blue: 22.0 / 255.0, alpha: 1);
                    indexLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
                    self.addSubview(indexLabel);
                    
                }else{
                    context.addLine(to: CGPoint(x: 15, y: Double(lineINCHIndex) * lineINCHSpacing));
                }
                lineINCHIndex += 1;
            }
            
            context.strokePath();
        }
    }

}
