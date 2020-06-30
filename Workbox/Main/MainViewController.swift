//
//  MainViewController.swift
//  Workbox
//
//  Created by 刘海 on 2017/1/10.
//  Copyright © 2017年 刘海. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.isKind(of: CalculatorViewController.classForCoder()) {
            self.navigationController?.navigationBar.isTranslucent = false;
        }else{
            self.navigationController?.navigationBar.isTranslucent = true;
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  showAlert(title :String?,message :String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertAction.Style.default, handler: nil));
        self.present(alert, animated: true, completion: nil);
    }
    
    //前置摄像头
    func frontCamera()->AVCaptureDevice?{
        return cameraWithPosition(position: AVCaptureDevice.Position.front);
    }
    
    //后置摄像头
    func backCamera()->AVCaptureDevice?{
        return cameraWithPosition(position: AVCaptureDevice.Position.back);
    }
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice?{
        let devices = AVCaptureDevice.devices(for: AVMediaType.video);
        for device:AVCaptureDevice in devices {
            if device.position == position {
                return device;
            }
        }
        return nil;
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
