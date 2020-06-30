//
//  GradienterViewController.swift
//  Workbox
//
//  Created by 刘海 on 2017/1/3.
//  Copyright © 2017年 刘海. All rights reserved.
//

import UIKit
import CoreMotion

class GradienterViewController: MainViewController {
        
    var centerView:         UIView!;
    var leftView:           UIView!;
    var bottomView:         UIView!;
    var centerPoint:        CGPoint!;
    
    var radiusXLabel:        UILabel!;
    var radiusYLabel:        UILabel!;
    
    let motionManager:CMMotionManager = CMMotionManager();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        centerPoint = CGPoint(x: screenObject.width / 2.0 , y: screenObject.height / 2.0);
        
        let grabgView = GradienterBackgroundView(frame: CGRect(x: 0, y: 0, width: screenObject.width, height: screenObject.height));
        self.view.addSubview(grabgView);
        
        centerView = UIView(frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0));
        centerView.layer.cornerRadius = 20.0;
        centerView.backgroundColor = UIColor.white;
        self.view.addSubview(centerView);
        centerView.center = self.view.center;
        
        leftView = UIView(frame: CGRect(x: 72.0 - 30.0 - 13.0, y: (screenObject.height - 26.0) / 2.0, width: 26.0, height: 26.0));
        leftView.layer.cornerRadius = 13.0;
        leftView.backgroundColor = UIColor.white;
        self.view.addSubview(leftView);
        
        bottomView = UIView(frame: CGRect(x: (screenObject.width - 26.0) / 2.0, y: (screenObject.height - (screenObject.width - 144.0)) / 2.0 + (screenObject.width - 144.0) + 17.0, width: 26.0, height: 26.0));
        bottomView.layer.cornerRadius = 13.0;
        bottomView.backgroundColor = UIColor.white;
        self.view.addSubview(bottomView);
        
        let grafgView = GradienterFrontgroundView(frame: CGRect(x: 0, y: 0, width: screenObject.width, height: screenObject.height));
        self.view.addSubview(grafgView);
        
        radiusXLabel = UILabel(frame: CGRect(x: 0, y: 85, width: screenObject.width / 2.0, height: 40.0));
        radiusXLabel.backgroundColor = UIColor.clear;
        radiusXLabel.text = "X:0.0°";
        radiusXLabel.textAlignment = .center;
        radiusXLabel.font = UIFont.systemFont(ofSize: 28);
        radiusXLabel.textColor = UIColor.white;
        self.view.addSubview(radiusXLabel);
        
        radiusYLabel = UILabel(frame: CGRect(x: screenObject.width / 2.0, y: 85, width: screenObject.width / 2.0, height: 40.0));
        radiusYLabel.backgroundColor = UIColor.clear;
        radiusYLabel.text = "Y:0.0°";
        radiusYLabel.textAlignment = .center;
        radiusYLabel.font = UIFont.systemFont(ofSize: 28);
        radiusYLabel.textColor = UIColor.white;
        self.view.addSubview(radiusYLabel);
        
        let backButton = UIButton(frame: CGRect(x: 5, y: 25, width: 40, height: 40));
        backButton.setImage(UIImage(named:"ud_back"), for: UIControl.State.normal);
        backButton.addTarget(self, action: #selector(back), for: UIControl.Event.touchUpInside);
        self.view.addSubview(backButton);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true);
        
        //启动陀螺仪
        startAcce();
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true);
        
        
        //关闭陀螺仪
        stopAcce();
    }
    
    
    
    func startAcce() {
        if motionManager.isAccelerometerAvailable {
            //陀螺仪可用
            //更新频率
            
            motionManager.accelerometerUpdateInterval = 0.01;
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {
                (cmdeviceMotion, error) in
                //动态设置小球位置
                let speedX = CGFloat(cmdeviceMotion!.gravity.x);
                let speedY =  CGFloat(cmdeviceMotion!.gravity.y);
                
                self.centerView.center = CGPoint(x: self.centerPoint.x - speedX * ((screenObject.width - 144.0 - self.centerView.frame.width) / 2.0),y: self.centerPoint.y + speedY * ((screenObject.width - 144.0 - self.centerView.frame.height) / 2.0));
                
                if fabs(self.centerView.center.x - self.centerPoint.x) <= 5 &&
                    fabs(self.centerView.center.y - self.centerPoint.y) <= 5 {
                    
                    if self.centerView.backgroundColor != Color(red: 227.0, green: 35.0, blue: 35.0, alpha: 1){
                        UIView.animate(withDuration: 0.1, animations: { 
                            self.centerView.backgroundColor = Color(red: 227.0, green: 35.0, blue: 35.0, alpha: 1);
                        });
                    }
                }else{
                    if self.centerView.backgroundColor != UIColor.white{
                        UIView.animate(withDuration: 0.1, animations: {
                            self.centerView.backgroundColor = UIColor.white;
                        });
                    }
                }
                
                
                self.leftView.center.y = self.centerPoint.y + speedY * ((screenObject.width - 144.0) / 2.0);
                
                if fabs(self.leftView.center.y - self.centerPoint.y) <= 5{
                    if self.leftView.backgroundColor != Color(red: 227.0, green: 35.0, blue: 35.0, alpha: 1){
                        UIView.animate(withDuration: 0.1, animations: {
                            self.leftView.backgroundColor = Color(red: 227.0, green: 35.0, blue: 35.0, alpha: 1);
                        });
                    }
                }else{
                    if self.leftView.backgroundColor != UIColor.white{
                        UIView.animate(withDuration: 0.1, animations: {
                            self.leftView.backgroundColor = UIColor.white;
                        });
                    }
                }
                
                //计算偏移角度
                let x1 = screenObject.width / 2.0;
                let y1 = screenObject.height / 2.0;
                
                let x2 = self.leftView.center.x;
                let y2 = self.leftView.center.y;
                
                let radianx = atan((Double(x2)-Double(x1))/(Double(y2) - Double(y1)));
                var anglex = RadianToAngle(angle: CGFloat(radianx));
                if anglex > 0{
                    anglex = 90.0 - anglex;
                }else {
                    anglex = -(anglex + 90.0);
                }
                anglex = anglex * (90.0 / 39.3);
                self.radiusYLabel.text = "Y:" + String(format: "%.1f", floorToPlaces(value: Double(anglex), places: 1)) + "°"
                
                
                self.bottomView.center.x = self.centerPoint.x - speedX * ((screenObject.width - 144.0) / 2.0);
                
                if fabs(self.bottomView.center.x - self.centerPoint.x) <= 5{
                    if self.bottomView.backgroundColor != Color(red: 227.0, green: 35.0, blue: 35.0, alpha: 1){
                        UIView.animate(withDuration: 0.1, animations: {
                            self.bottomView.backgroundColor = Color(red: 227.0, green: 35.0, blue: 35.0, alpha: 1);
                        });
                    }
                }else{
                    if self.bottomView.backgroundColor != UIColor.white{
                        UIView.animate(withDuration: 0.1, animations: {
                            self.bottomView.backgroundColor = UIColor.white;
                        });
                    }
                }
                
                let x4 = self.bottomView.center.x;
                let y4 = self.bottomView.center.y;
                
                let radiany = atan((Double(x4)-Double(x1))/(Double(y4) - Double(y1)));
                let angley = RadianToAngle(angle: CGFloat(radiany)) * (90.0 / 39.3);
                self.radiusXLabel.text = "X:" + String(format: "%.1f", floorToPlaces(value: Double(angley), places: 1)) + "°"
            })
        }
    }
    
    func stopAcce() {
        if motionManager.isAccelerometerAvailable {
            motionManager.stopAccelerometerUpdates();
        }
    }

    
    @objc func back() {
        self.navigationController!.popViewController(animated: true);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
