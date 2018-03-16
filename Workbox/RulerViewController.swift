//
//  RulerViewController.swift
//  Workbox
//
//  Created by 刘海 on 2016/12/7.
//  Copyright © 2016年 刘海. All rights reserved.
//

import UIKit

class RulerViewController: MainViewController {

    var screenObject=UIScreen.main.bounds;
    var isShowNavigationBar:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let rulerbg:RulerBackgroundView = RulerBackgroundView(frame:CGRect(x:0,y:74,width:screenObject.width,height:screenObject.height - 74));
        rulerbg.backgroundColor = UIColor.clear;
        self.view.addSubview(rulerbg);
        
        let rulerCon:RulerControlView = RulerControlView(frame: CGRect(x: 0, y: 64, width: screenObject.width, height: screenObject.height - 64.0));
        self.view.addSubview(rulerCon);
        
        
//        let singleRecognizer:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(showNavigationBar));
//        singleRecognizer.numberOfTapsRequired = 1;
//        self.view.addGestureRecognizer(singleRecognizer);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
//        self.title = "直尺";
//        self.navigationController?.setNavigationBarHidden(true, animated: false);
        
//        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.slide);
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
//        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.slide)
    }
    
//    func showNavigationBar(){
//        self.navigationController?.setNavigationBarHidden(isShowNavigationBar, animated: true);
//        isShowNavigationBar = !isShowNavigationBar;
//    }

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
