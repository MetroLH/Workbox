//
//  DecibelViewController.swift
//  Workbox
//  分贝测试仪
//  Created by 刘海 on 2017/1/5.
//  Copyright © 2017年 刘海. All rights reserved.
//

import UIKit
import AVFoundation

class DecibelViewController: MainViewController,UITableViewDelegate,UITableViewDataSource {
    
    var reference:      [String]!;
    var dbLabel:        UILabel!;
    var pointerView:    UIView!;
    
    var recorder:       AVAudioRecorder!;
    var levelTimer:     Timer!;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        reference = [
            "1db: 刚能听到的声音",
            "<15db: 感觉安静",
            "30db: 耳语的音量大小",
            "40db: 冰箱的嗡嗡声",
            "60db: 正常交谈的声音",
            "70db: 相当于走在闹市区",
            "85db: 汽车穿梭的马路上",
            "95db: 摩托车启动声音",
            "100db: 装修电钻的声音",
            "110db: 卡拉OK、大声播放MP3 的声音",
            "120db: 飞机起飞时的声音",
            "150db: 燃放烟花爆竹的声音"
        ];
        
        let decibelView = DecibelBackgroundView(frame: CGRect(x:0,y:64,width:screenObject.width,height:screenObject.height / 2.0 + 50 - 64.0));
        self.view.addSubview(decibelView);
        
        pointerView = UIView(frame: CGRect(x: 40, y: screenObject.height / 2.0 + 20, width: screenObject.width - 80, height: 2));
        pointerView.backgroundColor = Color(red: 255, green: 104, blue: 107, alpha: 1);
        pointerView.layer.cornerRadius = 1;
        self.view.addSubview(pointerView);
        
        let tempView = UIView(frame: CGRect(x: 0, y: 64.0 + decibelView.frame.height - 34.0, width: screenObject.width, height: 35.0));
        tempView.backgroundColor = UIColor.white;
        self.view.addSubview(tempView);
        
        dbLabel = UILabel(frame: CGRect(x: (screenObject.width - screenObject.width / 9.0) / 2.0, y: 64.0 + decibelView.frame.height - screenObject.width / 9.0 + 1.0, width: screenObject.width / 9.0, height: screenObject.width / 9.0));
        dbLabel.backgroundColor = Color(red: 255, green: 104, blue: 107, alpha: 1);
        dbLabel.adjustsFontSizeToFitWidth = true;
        dbLabel.text = "0";
        dbLabel.textAlignment = .center;
        dbLabel.layer.cornerRadius = (screenObject.width / 9.0) / 2.0;
        dbLabel.layer.masksToBounds = true;
        dbLabel.font = UIFont.systemFont(ofSize: 26);
        dbLabel.textColor = UIColor.white;
        self.view.addSubview(dbLabel);
        
        let tableView = UITableView(frame: CGRect(x:0,y:65.0 + decibelView.frame.height,width:screenObject.width,height:screenObject.height - decibelView.frame.height - 65.0), style: UITableViewStyle.plain);
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = UIColor.white;
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "referenceCell");
        self.view.addSubview(tableView);
        
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            if granted{
                /* 必须添加这句话，否则在模拟器可以，在真机上获取始终是0  */
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord);
                } catch let error as NSError {
                    print("AVAudioSession error : ",error)
                }
                
                let url = NSURL.fileURL(withPath: "/dev/null");
                
                let settings:[String:Any] = [AVSampleRateKey:           NSNumber(value: 44100.0),
                                             AVFormatIDKey:             NSNumber(value: kAudioFormatAppleLossless),
                                             AVNumberOfChannelsKey:     NSNumber(value: 2),
                                             AVEncoderAudioQualityKey:  AVAudioQuality.max.rawValue
                ];
                
                do {
                    try self.recorder = AVAudioRecorder(url: url, settings: settings);
                } catch let error as NSError {
                    print("AVAudioRecorder error : ",error)
                }
                if self.recorder != nil {
                    self.recorder.prepareToRecord();
                    self.recorder.isMeteringEnabled = true;
                    self.recorder.record();
                    
                    
                    self.levelTimer = Timer(timeInterval: 0.1, target: self, selector: #selector(DecibelViewController.levelTimerCallback(timer:)), userInfo: nil, repeats: true);
                    
                    // 将定时器添加到运行循环
                    RunLoop.current.add(self.levelTimer, forMode: RunLoopMode.commonModes);
                }
            }
        }
    }
    
    func levelTimerCallback(timer: Timer){
        
        self.recorder.updateMeters();
        
        var level = 0.0;            // The linear 0.0 .. 1.0 value we need.
        let minDecibels = -80.0;    // Or use -60dB, which I measured in a silent room.
        let decibels = self.recorder.averagePower(forChannel: 0); //-160 ~ 0
        
        if Double(decibels) < minDecibels{
            level = 0.0;
        }else if(decibels >= 0.0){
            level = 1.0;
        }else{
//            print("decibels = ",decibels);
            let root = 2.0;
            let minAmp = pow(10.0, 0.05 * minDecibels);
            let inverseAmpRange = 1.0 / (1.0 - minAmp);
            let amp = pow(10.0, 0.05 * Double(decibels));
            let adjAmp = (amp - minAmp) * inverseAmpRange;
            
            level = pow(adjAmp, 1.0 / root);
        }
        
        /* level 范围[0 ~ 1], 转为[0 ~150] 之间 */
        DispatchQueue.main.async {
            let leveldb = Double(level * 150.0);
            self.dbLabel.text = String(format: "%.0f", leveldb);
            
            self.dbLabel.textColor = UIColor.white;
            
            UIView.animate(withDuration: 0.1, animations: { 
                self.pointerView.transform = CGAffineTransform(rotationAngle: AngleToRadian(angle: CGFloat(leveldb * (180.0 / 150.0))));
            });
        }
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reference.count;
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35;
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            //为了提供表格显示性能，已创建完成的单元需重复使用
            let identify:String = "referenceCell"
            //同一形式的单元格重复使用，在声明时已注册
            let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath);
            cell.accessoryType = .none;
            cell.selectionStyle = .none;

            cell.textLabel?.textColor = Color(red: 22, green: 22, blue: 22, alpha: 1);
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13);
            cell.textLabel?.text = reference[indexPath.row];
            
            return cell
    }

    override func viewDidDisappear(_ animated: Bool) {
        if self.levelTimer != nil{
            self.levelTimer.invalidate();
            self.levelTimer = nil;
        }
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
