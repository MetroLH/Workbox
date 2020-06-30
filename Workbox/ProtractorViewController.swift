//
//  ProtractorViewController.swift
//  Workbox
//
//  Created by 刘海 on 2016/12/30.
//  Copyright © 2016年 刘海. All rights reserved.
//

import UIKit
import AVFoundation

class ProtractorViewController: MainViewController {
    
    var session:            AVCaptureSession!;
    var previewLayer:       AVCaptureVideoPreviewLayer!;
    var cameraShowView:     UIView!;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let pBgView = ProtractorBackgroundView(frame: CGRect(x: 50, y: 64, width: screenObject.width - 50.0, height: screenObject.height - 64.0));
        
        self.view.addSubview(pBgView);
        
        let pVer = ProtractorVernierView(frame: CGRect(x: 50, y: 64, width: screenObject.width - 50.0, height: screenObject.height - 64.0));
        self.view.addSubview(pVer);
        
        
        let cameraBtn = UIButton(frame: CGRect(x: screenObject.width - 50, y: screenObject.height - 50, width: 40, height: 40));
        cameraBtn.setImage(UIImage(named: "camera_off"), for: UIControl.State.normal);
        cameraBtn.setImage(UIImage(named: "camera_on"), for: UIControl.State.selected);
        cameraBtn.addTarget(self, action: #selector(cameraBtn(btn:)), for: UIControl.Event.touchUpInside);
        self.view.addSubview(cameraBtn);
    }

    
    @objc func cameraBtn(btn : UIButton){
        btn.isSelected = !btn.isSelected;
        
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
        case .notDetermined:
            // 许可对话没有出现，发起授权许可
            AVCaptureDevice.requestAccess(for: AVMediaType.video,
                                                      completionHandler: { (granted:Bool) -> Void in
                                                        if granted {
                                                            // 继续
                                                            if btn.isSelected {
                                                                //启动照相机
                                                                self.setupCamera();
                                                            }else {
                                                                //关闭照相机
                                                                self.closeCamera();
                                                            }
                                                        }
                                                        else {
                                                            // 用户拒绝，无法继续
                                                            self.showAlert(title: nil, message: NSLocalizedString("cameraerror", comment: ""));
                                                        }
            })
        case .authorized:
            // 继续
            if btn.isSelected {
                //启动照相机
                setupCamera();
            }else {
                //关闭照相机
                closeCamera();
            }
            break;
        case .denied, .restricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            self.showAlert(title: nil, message: NSLocalizedString("cameraerror", comment: ""));
            break;
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCamera(){
        initCameraSession();
        
        if previewLayer == nil {
            previewLayer = AVCaptureVideoPreviewLayer(session: self.session);
            
            cameraShowView = UIView(frame: CGRect(x: 0, y: 0, width: screenObject.width, height: screenObject.height));
            
            let viewLayer = cameraShowView.layer;
            viewLayer.masksToBounds = true;
            
            previewLayer.frame = cameraShowView.bounds;
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
            
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
        }
    }

    func initCameraSession(){
        if session == nil {
            session = AVCaptureSession();
            
            do {
                let videoInput = try AVCaptureDeviceInput(device: backCamera()!);
                if session.canAddInput(videoInput) {
                    session.addInput(videoInput);
                }
                session.sessionPreset = AVCaptureSession.Preset.photo
                session.startRunning()
            } catch let error as NSError {
                print("camera error : ",error)
            }
        }
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
