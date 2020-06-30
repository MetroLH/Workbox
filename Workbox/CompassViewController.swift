//
//  CompassViewController.swift
//  Workbox
//  指南针
//  Created by 刘海 on 2017/1/6.
//  Copyright © 2017年 刘海. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class CompassViewController: MainViewController,CLLocationManagerDelegate {

    var radius:             CGFloat!;
    var centerPoint:        CGPoint!;
    var comBG:              CompassBackgroundView!;
    var comCenterBg:        CompassCenterView!;
    var angleLabel:         UILabel!;
    let array               = [NSLocalizedString("bei", comment: ""),
                               NSLocalizedString("dongbei", comment: ""),
                               NSLocalizedString("dong", comment: ""),
                               NSLocalizedString("dongnan", comment: ""),
                               NSLocalizedString("nan", comment: ""),
                               NSLocalizedString("xinan", comment: ""),
                               NSLocalizedString("xi", comment: ""),
                               NSLocalizedString("xibei", comment: "")];
    
    let locationManager:    CLLocationManager = CLLocationManager();
    let motionManager:      CMMotionManager = CMMotionManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radius = (screenObject.width - 20.0) / 2.0;
        centerPoint = CGPoint(x: screenObject.width / 2.0 , y: screenObject.height / 2.0);

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = Color(red: 22, green: 22, blue: 22, alpha: 1);
        
        comBG = CompassBackgroundView(frame: CGRect(x: (screenObject.width - radius * 2.0) / 2.0, y: (screenObject.height - radius * 2.0) / 2.0, width: radius * 2.0, height: radius * 2.0),radius: radius);
        self.view.addSubview(comBG);
        
        comCenterBg = CompassCenterView(frame: CGRect(x: (screenObject.width - (radius * 0.3) * 2.0) / 2.0, y: (screenObject.height - (radius * 0.3) * 2.0) / 2.0, width: (radius * 0.3) * 2.0, height: (radius * 0.3) * 2.0),radius: radius);
        self.view.addSubview(comCenterBg);
        
        let frontView = CompassFrontgroundView(frame: CGRect(x: 0, y: 0, width: screenObject.width, height: screenObject.height), radius: radius);
        self.view.addSubview(frontView);
        
        angleLabel = UILabel(frame: CGRect(x: 0, y: screenObject.height / 2.0 - radius - 50.0, width: screenObject.width, height: 40.0));
        angleLabel.backgroundColor = UIColor.clear;
        angleLabel.text = "0.0° ";
        angleLabel.textAlignment = .center;
        angleLabel.font = UIFont.systemFont(ofSize: 28);
        angleLabel.textColor = UIColor.white;
        self.view.addSubview(angleLabel);
        
        let backButton = UIButton(frame: CGRect(x: 5, y: 25, width: 40, height: 40));
        backButton.setImage(UIImage(named:"ud_back"), for: UIControl.State.normal);
        backButton.addTarget(self, action: #selector(back), for: UIControl.Event.touchUpInside);
        self.view.addSubview(backButton);
        
        locationManager.delegate = self;
    }
    
    //启动定位
    func startLocation(){
        if CLLocationManager.headingAvailable() {
            locationManager.headingFilter = 1;
            locationManager.startUpdatingHeading();
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy < 0 {
            return;
        }
        let theHeading: CLLocationDirection = (newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading;
        
//        print("heading :",theHeading);
        
        if theHeading < 22 || theHeading >= 338{
            self.angleLabel.text = String(format: "%.1f", floorToPlaces(value: Double(theHeading), places: 1)) + "° " + array[0];
        }else if theHeading >= 22 && theHeading < 67{
            self.angleLabel.text = String(format: "%.1f", floorToPlaces(value: Double(theHeading), places: 1)) + "° " + array[1];
        }else if theHeading >= 67 && theHeading < 113{
            self.angleLabel.text = String(format: "%.1f", floorToPlaces(value: Double(theHeading), places: 1)) + "° " + array[2];
        }else if theHeading >= 113 && theHeading < 158{
            self.angleLabel.text = String(format: "%.1f", floorToPlaces(value: Double(theHeading), places: 1)) + "° " + array[3];
        }else if theHeading >= 158 && theHeading < 202{
            self.angleLabel.text = String(format: "%.1f", floorToPlaces(value: Double(theHeading), places: 1)) + "° " + array[4];
        }else if theHeading >= 202 && theHeading < 248{
            self.angleLabel.text = String(format: "%.1f", floorToPlaces(value: Double(theHeading), places: 1)) + "° " + array[5];
        }else if theHeading >= 248 && theHeading < 292{
            self.angleLabel.text = String(format: "%.1f", floorToPlaces(value: Double(theHeading), places: 1)) + "° " + array[6];
        }else if theHeading >= 292 && theHeading < 338{
            self.angleLabel.text = String(format: "%.1f", floorToPlaces(value: Double(theHeading), places: 1)) + "° " + array[7];
        }
        
        
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [UIView.AnimationOptions.beginFromCurrentState,UIView.AnimationOptions.curveEaseOut,UIView.AnimationOptions.allowUserInteraction], animations: {
            
            self.comBG.transform = CGAffineTransform(rotationAngle: CGFloat(-AngleToRadian(angle: CGFloat(theHeading))));
            
        }) { (finished) in
            
        }
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [UIView.AnimationOptions.beginFromCurrentState,UIView.AnimationOptions.curveEaseOut,UIView.AnimationOptions.allowUserInteraction], animations: {
            self.comBG.transform = CGAffineTransform(rotationAngle: CGFloat(AngleToRadian(angle: 0) - AngleToRadian(angle: CGFloat(theHeading))));
        }) { (finished) in
            
        }
    }
    func stopLocation(){
        if CLLocationManager.headingAvailable() {
            locationManager.stopUpdatingHeading();
        }
    }
    //启动陀螺仪
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
                
                let width = (screenObject.width - self.radius * 0.3 - self.comCenterBg.frame.width) / 2.0;
                let height = (screenObject.width - self.radius * 0.3 - self.comCenterBg.frame.height) / 2.0;
                
                
                let x = self.centerPoint.x - speedX * width;
                let y = self.centerPoint.y + speedY * height;
                
                
                self.comCenterBg.center = CGPoint(x: x, y: y);
            })
        }
    }
    
    func stopAcce() {
        if motionManager.isAccelerometerAvailable {
            motionManager.stopAccelerometerUpdates();
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true);
        startAcce();
        startLocation();
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true);
        stopAcce();
        stopLocation();
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
