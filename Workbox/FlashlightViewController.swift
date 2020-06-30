//
//  FlashlightViewController.swift
//  Workbox
//  手电筒
//  Created by 刘海 on 2017/1/12.
//  Copyright © 2017年 刘海. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class FlashlightViewController: MainViewController {

    @IBOutlet var flashBtn  :UIButton!;
    @IBOutlet var sosBtn : UIButton!;
    var device :    AVCaptureDevice!;
    
    var shortTimer:     Timer?;
    var longTimer:      Timer?;
    
    var shortCount       = 0;
    var shortNumber      = 0;
    var longCount        = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        sosBtn.layer.cornerRadius = sosBtn.frame.width / 2.0;
        
        device = AVCaptureDevice.default(for: AVMediaType.video);
        if !device.hasTorch {
            self.showAlert(title: "", message: NSLocalizedString("flasherror", comment: ""));
        }

        
    }
    
    @IBAction func flashlightSwitch(btn : UIButton){
        
        if !device.hasTorch {
            return;
        }
        
        //关闭计时器
        if shortTimer != nil{
            shortTimer?.invalidate();
            shortTimer = nil;
        }
        if longTimer != nil{
            longTimer?.invalidate();
            longTimer = nil;
        }
        shortNumber = 0;
        shortCount = 0;
        longCount = 0;
        
        playSound();
        
        if device.torchMode == AVCaptureDevice.TorchMode.on {
            //关闭手电筒
            do {
                try device.lockForConfiguration();
                device.torchMode = AVCaptureDevice.TorchMode.off;
                device.unlockForConfiguration();
            } catch let error {
                print("device error : " ,error);
            }
            btn.isSelected = false;
        }else{
            //开启手电筒
            do {
                try device.lockForConfiguration();
                device.torchMode = AVCaptureDevice.TorchMode.on;
                device.unlockForConfiguration();
            } catch let error {
                print("device error : " ,error);
            }
            btn.isSelected = true;
        }

    }
    
    func flashon(){
        if device.torchMode == AVCaptureDevice.TorchMode.on {
            //关闭手电筒
            do {
                try device.lockForConfiguration();
                device.torchMode = AVCaptureDevice.TorchMode.off;
                device.unlockForConfiguration();
            } catch let error {
                print("device error : " ,error);
            }
            self.flashBtn.isSelected = false;
        }else{
            //开启手电筒
            do {
                try device.lockForConfiguration();
                device.torchMode = AVCaptureDevice.TorchMode.on;
                device.unlockForConfiguration();
            } catch let error {
                print("device error : " ,error);
            }
            self.flashBtn.isSelected = true;
        }
    }

    @IBAction func startSOS(btn : UIButton){
        
        if !device.hasTorch {
            return;
        }
        
        //先启动短定时器
        if shortTimer == nil{
            shortTimer = Timer(timeInterval: 0.2, target: self, selector: #selector(shortFlash(timer:)), userInfo: nil, repeats: true);
            // 将定时器添加到运行循环
            RunLoop.current.add(shortTimer!, forMode: RunLoop.Mode.common);
        }

    }
    
    @objc func shortFlash(timer: Timer){
        if shortNumber < 2{
            if shortCount < 6{
                flashon();
                shortCount += 1;
            }else{
                if shortTimer != nil{
                    shortTimer?.invalidate();
                    shortTimer = nil;
                }
                if longTimer == nil{
                    //启动长计时器
                    longTimer = Timer(timeInterval: 0.6, target: self, selector: #selector(longFlash(timer:)), userInfo: nil, repeats: true);
                    // 将定时器添加到运行循环
                    RunLoop.current.add(longTimer!, forMode: RunLoop.Mode.common);
                }

                
            }
        }else{
            if shortTimer != nil{
                shortTimer?.invalidate();
                shortTimer = nil;
            }
            if longTimer != nil{
                longTimer?.invalidate();
                longTimer = nil;
            }
            shortNumber = 0;
            shortCount = 0;
            longCount = 0;
        }
    }
    
    @objc func longFlash(timer: Timer){
        if longCount < 6{
            flashon();
            longCount += 1;
        }else{
            if longTimer != nil{
                longTimer?.invalidate();
                longTimer = nil;
            }
            shortCount = 0;
            if shortTimer == nil{
                shortTimer = Timer(timeInterval: 0.2, target: self, selector: #selector(shortFlash(timer:)), userInfo: nil, repeats: true);
                // 将定时器添加到运行循环
                RunLoop.current.add(shortTimer!, forMode: RunLoop.Mode.common);
            }
            //短计时器次数+1
            shortNumber += 1;
        }
    }
    
    func playSound(){
        // 声明要保存音效文件的变量
        var soundID:SystemSoundID = 0
        
        // 加载文件
        let pathString = Bundle.main.path(forResource: "flashon", ofType: "wav");
        
        let fileUrl = NSURL(fileURLWithPath: pathString!);

        AudioServicesCreateSystemSoundID(fileUrl, &soundID);
        
        // 播放短频音效
        AudioServicesPlayAlertSound(soundID);
        
        // 增加震动效果，如果手机处于静音状态，提醒音将自动触发震动
//        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate));
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
