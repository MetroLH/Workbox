//
//  MirrorViewController.swift
//  Workbox
//  镜子
//  Created by 刘海 on 2017/1/12.
//  Copyright © 2017年 刘海. All rights reserved.
//

import UIKit
import AVFoundation
import GLKit

class MirrorViewController: MainViewController {

    var session:            AVCaptureSession!;
    var device:             AVCaptureDevice!;
    var previewLayer:       AVCaptureVideoPreviewLayer!;
    var cameraShowView:     UIView!;
    var showView:           UIView!;
    @IBOutlet var slider:   UISlider!;
    
    @IBOutlet var quan1:    UILabel!;
    @IBOutlet var quan2:    UILabel!;
    
    var currentLight:       CGFloat!;//保存之前的屏幕亮度
    
//    var glContext:          EAGLContext!;
//    var glView:             GLKView!;
//    var ciContext:          CIContext!;
//    var videoOutput:        AVCaptureVideoDataOutput!;
//    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white;
        
        showView = UIView(frame: CGRect(x: -20, y: -20, width: screenObject.width + 40, height: screenObject.height + 40));
        showView.backgroundColor = UIColor.clear;
        showView.layer.borderColor = UIColor.clear.cgColor;
        showView.layer.borderWidth = 20.0;
        self.view.insertSubview(showView, belowSubview: self.view.subviews[0]);
        
        let backButton = UIButton(frame: CGRect(x: 5, y: 25, width: 40, height: 40));
        backButton.setImage(UIImage(named:"ud_back"), for: UIControl.State.normal);
        backButton.addTarget(self, action: #selector(back), for: UIControl.Event.touchUpInside);
        self.view.addSubview(backButton);
    }

    func setupCamera(){
        initCameraSession();
        
        if previewLayer == nil {
            previewLayer = AVCaptureVideoPreviewLayer(session: self.session);
            
            cameraShowView = UIView(frame: CGRect(x: 0, y: 0, width: showView.frame.width, height: showView.frame.height));
            cameraShowView.backgroundColor = UIColor.white;
            
            let viewLayer = cameraShowView.layer;
            viewLayer.masksToBounds = true;
            
            previewLayer.frame = cameraShowView.bounds;
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
            
            viewLayer.addSublayer(previewLayer);
            
            self.view.insertSubview(cameraShowView, belowSubview: self.view.subviews[0]);
        }
        
//        glContext = EAGLContext(api: EAGLRenderingAPI.openGLES2);
//        glView = GLKView(frame: CGRect(x: 0, y: 0, width: screenObject.width, height: screenObject.height), context: glContext)
//        ciContext = CIContext(eaglContext: glContext);
//        videoOutput = AVCaptureVideoDataOutput();
//        let dispatchQueue = DispatchQueue(label: "sample buffer delegate");
//        videoOutput.setSampleBufferDelegate(self, queue: dispatchQueue);
//        if session.canAddOutput(self.videoOutput) {
//            session.addOutput(self.videoOutput)
//        }
//        self.view.insertSubview(glView, belowSubview: self.view.subviews[0]);
    }
    
//    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
//        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//        let image = CIImage(cvPixelBuffer: pixelBuffer!);
//        if glContext != EAGLContext.current() {
//            EAGLContext.setCurrent(glContext);
//        }
//        glView.bindDrawable()
//        ciContext.draw(image, in: image.extent, from: image.extent);
//        glView.display()
//    }
//    
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
            
            device = AVCaptureDevice.default(for: AVMediaType.video);
//            if device.isExposureModeSupported(AVCaptureExposureMode.custom){
//                
//                do {
//                    try device.lockForConfiguration();
//                    device.exposureMode = AVCaptureExposureMode.custom;
//                    
//                    device.unlockForConfiguration();
//                } catch let error {
//                    print("device error : " ,error);
//                }
//                slider.minimumValue = device.minExposureTargetBias;
//                slider.maximumValue = device.maxExposureTargetBias;
//                slider.value = 0;
//            }else{
//                slider.isHidden = true;
//            }
            
            
            do {
                let videoInput = try AVCaptureDeviceInput(device: frontCamera()!);
                if session.canAddInput(videoInput) {
                    session.addInput(videoInput);
                }
                session.sessionPreset = AVCaptureSession.Preset.photo;
                session.startRunning();
            } catch let error as NSError {
                print("camera error : ",error)
            }
        }
    }
    
    @IBAction func sliderValueChanged(slider : UISlider){
        
        //缩放cameraShowView
        UIView.animate(withDuration: 0.2) { 
            self.cameraShowView.transform = CGAffineTransform(scaleX: 1.0 + (CGFloat(slider.value) * 10.0) / 2.0, y: 1.0 + (CGFloat(slider.value) * 10.0) / 2.0);
        };
        
//        do {
//            
//            try device.lockForConfiguration();
//            
//            device.setExposureTargetBias(slider.value, completionHandler: { (time: CMTime) in
//                
//            });
//            
//            device.unlockForConfiguration();
//            
//        } catch let error {
//            print("device error : " ,error);
//        }
//        print("svalue : ",device.exposureTargetBias);
    }
    
    @IBAction func lightChange(btn : UIButton){
        btn.isSelected = !btn.isSelected;
        if btn.isSelected{
            //打开补光
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {

                
                self.showView.frame = CGRect(x: 0, y: 0, width: screenObject.width , height: screenObject.height);
                self.showView.layer.borderColor = UIColor.white.cgColor;
//                self.quan1.textColor = Color(red: 22, green: 22, blue: 22, alpha: 1);
//                self.quan2.textColor = Color(red: 22, green: 22, blue: 22, alpha: 1);
                
                //先记录当前的屏幕亮度
                self.currentLight = UIScreen.main.brightness;
                
                //修改平面镜亮度为最高
                UIScreen.main.brightness = 1.0;
                
            }, completion: { (finish: Bool) in
                
            });
        }else{
            //关闭补光
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                
                self.showView.frame = CGRect(x: -20, y: -20, width: screenObject.width + 40, height: screenObject.height + 40);
                self.showView.layer.borderColor = UIColor.clear.cgColor;
//                self.quan1.textColor = UIColor.white;
//                self.quan2.textColor = UIColor.white;
                
                UIScreen.main.brightness = self.currentLight;
                
            }, completion: { (finish: Bool) in
                
            });
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
        case .notDetermined:
            // 许可对话没有出现，发起授权许可
            AVCaptureDevice.requestAccess(for: AVMediaType.video,
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
