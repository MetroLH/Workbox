//
//  MoneyExchangeViewController.swift
//  Workbox
//  货币兑换
//  Created by 刘海 on 2017/1/6.
//  Copyright © 2017年 刘海. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class MoneyExchangeViewController: MainViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    
    @IBOutlet var moneyTF:UITextField!;
    @IBOutlet var currencyTF01:UITextField!;
    @IBOutlet var currencyTF02:UITextField!;
    
    @IBOutlet var moneyLabel:UILabel!;
    @IBOutlet var updateDateLabel:UILabel!;
    
    var cuttencyArray   :Array<JSON> = [];
    var selectCDict01     :JSON! = ["name":"人民币","code":"CNY"];
    var selectCDict02     :JSON! = ["name":"美元","code":"USD"];
    var selectIndex = 0;
    
    var exchangeRate    :Array<JSON> = [];

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let singleRecognizer:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(hidekeyboard));
        singleRecognizer.numberOfTapsRequired = 1;
        self.view.addGestureRecognizer(singleRecognizer);
        
        self.moneyTF.delegate = self;
        
        self.currencyTF01.text = self.selectCDict01["name"].string! + " " + self.selectCDict01["code"].string!;
        self.currencyTF02.text = self.selectCDict02["name"].string! + " " + self.selectCDict02["code"].string!;
        
        self.moneyLabel.text = "100 " + self.currencyTF01.text! + " = " + self.currencyTF02.text!;
        
        getMoneyList();
        
        //获取默认的抓换金额
        currency(from: selectCDict01["code"].string!, to: selectCDict02["code"].string!);
    }
    
    @IBAction func selectCuttency(btn : UIButton){
        if btn.tag == 100 {
            //选择币种1
            selectCuttencyWithIndex(index: 0);
        }else if btn.tag == 101{
            //选择币种2
            selectCuttencyWithIndex(index: 1);
        }
    }
    
    //互换
    @IBAction func exchangeBtn(btn : UIButton){
        swap(&self.selectCDict01, &self.selectCDict02);
        self.currencyTF01.text = self.selectCDict01["name"].string! + " " + self.selectCDict01["code"].string!;
        self.currencyTF02.text = self.selectCDict02["name"].string! + " " + self.selectCDict02["code"].string!;
        currency(from: selectCDict01["code"].string!, to: selectCDict02["code"].string!);
    }
    
    
    //计算兑换后的金额
    @IBAction func calculate(btn : UIButton){
        if moneyTF.canResignFirstResponder {
            moneyTF.resignFirstResponder();
        }
        
        if moneyTF.text == "" || Double(moneyTF.text!) == 0.0 {
            showAlert(title: nil, message: NSLocalizedString("qingshurujine", comment: "qingshurujine"));
            return;
        }
        
        //判断有几个小数点
        let num = moneyTF.text?.components(separatedBy: ".");
        if (num?.count)! > 2 {
            showAlert(title: nil, message: NSLocalizedString("qingshurujine", comment: "qingshurujine"));
            return;
        }
        //获取默认的抓换金额
        currency(from: selectCDict01["code"].string!, to: selectCDict02["code"].string!);
    }
    
    func selectCuttencyWithIndex(index :NSInteger){
        
        if cuttencyArray.count <= 0 {
            
            return;
        }
        
        selectIndex = index;
        
        let message:String = "\n\n\n\n\n\n\n\n\n";

        let sheet = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.actionSheet);
        
        sheet.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertAction.Style.default, handler: { (action) in
            
            //确定
            switch index {
            case 0:
                if self.selectCDict01 != nil{
                    print("selectDict01 : ",self.selectCDict01?.dictionary ?? "");
                    self.currencyTF01.text = self.selectCDict01["name"].string! + " " + self.selectCDict01["code"].string!;
                }
                break;
            default:
                if self.selectCDict02 != nil{
                    print("selectDict02 : ",self.selectCDict02?.dictionary ?? "");
                    self.currencyTF02.text = self.selectCDict02["name"].string! + " " + self.selectCDict02["code"].string!;
                }
                break;
                
            }
            
 
        }));
        sheet.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: UIAlertAction.Style.cancel, handler: { (action) in
            //取消
        }));
        
        self.present(sheet, animated: true, completion: nil);
        
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: sheet.view.frame.width - 20, height: 9 * 20 + 10));
        picker.backgroundColor = UIColor.clear;
        picker.delegate = self;
        picker.dataSource = self;
        sheet.view.addSubview(picker);
        
        //初始化已选数据
        switch index {
        case 0:
            if self.selectCDict01 != nil{
                var i = 0;
                while i < cuttencyArray.count {
                    let dict = cuttencyArray[i];
                    if dict["code"].string == self.selectCDict01["code"].string {
                        picker.selectRow(i, inComponent: 0, animated: false);
                        break;
                    }
                    i += 1;
                }
            }
            break;
        default:
            if self.selectCDict02 != nil{
                var i = 0;
                while i < cuttencyArray.count {
                    let dict = cuttencyArray[i];
                    if dict["code"].string == self.selectCDict02["code"].string {
                        picker.selectRow(i, inComponent: 0, animated: false);
                        break;
                    }
                    i += 1;
                }
            }
            break;
            
        }
        
    }
    
    //实时汇率查询换算
    func currency(from :String,to :String){
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        let url = "http://op.juhe.cn/onebox/exchange/currency";
        
        let parameters = ["key":"5f86b5213a5b2fcfb1312f27859bf234",
                          "from":from,
                          "to":to];
        let headers = ["Content-Type":"application/json"];
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
            }
            if response.result.isSuccess{
                if let jsonResult = response.result.value{
                    //解析数据
                    let jsonDic = JSON(jsonResult);
                    let reason = jsonDic["reason"].string!;
                    if reason == "successed" {
                        if let result = jsonDic["result"].array{
                            self.exchangeRate = result;
                            
                            //处理当前的汇率
                            let result01 = result[0]["result"].floatValue;
                            let money = Float(self.moneyTF.text!)! * result01;
                            let moneyStr = String(format: "%.4f", money);
                            
                            let updateTime = result[0]["updateTime"].string;
                            
                            DispatchQueue.main.async {
                                self.moneyLabel.text = self.moneyTF.text! + " " + self.currencyTF01.text! + " = " + moneyStr + " " + self.currencyTF02.text!;
                                print(NSLocalizedString("jinrongcankao", comment: "Error"));
                                self.updateDateLabel.text = NSLocalizedString("jinrongcankao", comment: "Error") + updateTime!;
                            }
                        }
                    }else{
                        self.showAlert(title: nil, message: NSLocalizedString("huilverror", comment: "huilverror"));
                    }
                    print("jsonDic : ",jsonDic);
                    
                }else{
                    print("NerWorking Response Error");
                }
                
            }else{
                let error = response.result.error;
                print("NerWorking Error :", error ?? "");
            }
            
        }
    }
    
    //获取接口的货币列表
    func getMoneyList(){
        
        let url = "http://op.juhe.cn/onebox/exchange/list";
        
        let parameters = ["key":"5f86b5213a5b2fcfb1312f27859bf234"];
        
        let headers = ["Content-Type":"application/json"];
        
        Alamofire.request(url, method:HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers:headers).responseJSON { (response) in

            if response.result.isSuccess{
                if let jsonResult = response.result.value{
                    //解析数据
                    let jsonDic = JSON(jsonResult);
                    let reason = jsonDic["reason"].string!;
                    if reason == "查询成功" {
                        self.cuttencyArray = jsonDic["result"]["list"].array ?? [];
                    }else{
                        self.showAlert(title: nil, message: NSLocalizedString("huobiliebiaoerror", comment: "huobiliebiaoerror"));
                    }
                }else{
                    print("NerWorking Response Error");
                }
                
            }else{
                let error = response.result.error;
                print("NerWorking Error :", error ?? "");
            }
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cuttencyArray.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dict = cuttencyArray[row];
        return dict["name"].string;
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch selectIndex {
        case 0:
            self.selectCDict01 = cuttencyArray[row];
            break;
        default:
            self.selectCDict02 = cuttencyArray[row];
            break;
        }
    }

    @objc func hidekeyboard(){
        if moneyTF.canResignFirstResponder {
            moneyTF.resignFirstResponder();
        }
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.moneyTF {
            return validateNumber(number: NSString(string: string));
        }
        return true;
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
