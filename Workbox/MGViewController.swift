//
//  MGViewController.swift
//  Workbox
//  放大镜
//  Created by 刘海 on 2017/1/12.
//  Copyright © 2017年 刘海. All rights reserved.
//

import UIKit
import AVFoundation
import GLKit

class MGViewController: MainViewController {
    
    var session:            AVCaptureSession!;
    var device:             AVCaptureDevice!;
    var previewLayer:       AVCaptureVideoPreviewLayer!;
    var output :            AVCaptureStillImageOutput!;
    var videoConnection:    AVCaptureConnection!;
    var maxScale:           CGFloat!;
    var cameraShowView:     UIView!;
    @IBOutlet var slider:   UISlider!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let backButton = UIButton(frame: CGRect(x: 5, y: 25, width: 40, height: 40));
        backButton.setImage(UIImage(named:"ud_back"), for: UIControlState.normal);
        backButton.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside);
        self.view.addSubview(backButton);
    }
    
    func setupCamera(){
        initCameraSession();
        
        if previewLayer == nil {
            previewLayer = AVCaptureVideoPreviewLayer(session: self.session);
            
            cameraShowView = UIView(frame: CGRect(x: 0, y: 0, width: screenObject.width, height: screenObject.height));
            
            let viewLayer = cameraShowView.layer;
            viewLayer.masksToBounds = true;
            
            previewLayer.frame = cameraShowView.bounds;
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            
            viewLayer.addSublayer(previewLayer);
            
            self.view.insertSubview(cameraShowView, belowSubview: self.view.subviews[0]);
        }
        
    }
    
    func closeCamera(){
        if session != nil {
            session.stopRunning();
            
            previewLayer.removeFromSuperlayer();
            previewLayer = nil;
            
            cameraShowView.removeFromSuperview();
            cameraShowView = nil;
            
            session = nil;
            device = nil;
        }
    }
    
    func initCameraSession(){
        if session == nil {
            session = AVCaptureSession();
            
            device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo);
            
            do {
                let videoInput = try AVCaptureDeviceInput(device: backCamera());
                if session.canAddInput(videoInput) {
                    session.addInput(videoInput);
                }
                let stillImageOutput = AVCaptureStillImageOutput();
                if session.canAddOutput(stillImageOutput){
                    session.addOutput(stillImageOutput);
                }
                session.sessionPreset = AVCaptureSessionPresetPhoto;
                session.startRunning();
            } catch let error as NSError {
                print("camera error : ",error)
            }
            
            output = self.session.outputs[0] as! AVCaptureStillImageOutput;
            videoConnection = output.connection(withMediaType: AVMediaTypeVideo);
            maxScale = videoConnection!.videoMaxScaleAndCropFactor;
            
            slider.minimumValue = 1.0;
            slider.maximumValue = Float(maxScale) / 50.0;
            slider.value = 1.0;
        }
    }
    
    @IBAction func sliderValueChanged(slider : UISlider){
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            print("value : ",slider.value);
            self.cameraShowView.transform = CGAffineTransform(scaleX: CGFloat(slider.value), y: CGFloat(slider.value));
            var videoScaleAndCropFactor = self.videoConnection!.videoScaleAndCropFactor;
            videoScaleAndCropFactor += CGFloat(slider.value);
            if videoScaleAndCropFactor > self.maxScale{
                videoScaleAndCropFactor = self.maxScale;
            }
            self.videoConnection!.videoScaleAndCropFactor = videoScaleAndCropFactor;
            print("videoScaleAndCropFactor : ",self.videoConnection!.videoScaleAndCropFactor);
        }, completion: { (finish: Bool) in
            
        });
    }
    
    @IBAction func lightChange(btn : UIButton){

        if !device.hasTorch {
            self.showAlert(title: "", message: NSLocalizedString("flasherror", comment: ""));
            return;
        }
        if device.torchMode == AVCaptureTorchMode.on {
            //关闭手电筒
            btn.isSelected = false;
            do {
                try device.lockForConfiguration();
                device.torchMode = AVCaptureTorchMode.off;
                device.unlockForConfiguration();
            } catch let error {
                print("device error : " ,error);
            }
            btn.isSelected = false;
        }else{
            //开启手电筒
            btn.isSelected = true;
            do {
                try device.lockForConfiguration();
                device.torchMode = AVCaptureTorchMode.on;
                device.unlockForConfiguration();
            } catch let error {
                print("device error : " ,error);
            }
            btn.isSelected = true;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        
        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authorizationStatus {
        case .notDetermined:
            // 许可对话没有出现，发起授权许可
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo,
                                          completionHandler: { (granted:Bool) -> Void in
                                            if granted {
                                                // 继续
                                                self.setupCamera();
                                            }
                                            else {
                                                // 用户拒绝，无法继续
                                                self.showAlert(title: nil, message: NSLocalizedString("cameraerror", comment: ""));
                                            }
            })
        case .authorized:
            // 继续
            setupCamera();
            break;
        case .denied, .restricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            self.showAlert(title: nil, message: NSLocalizedString("cameraerror", comment: ""));
            break;
        }
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        closeCamera();
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func back() {
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
