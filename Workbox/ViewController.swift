//
//  ViewController.swift
//  Workbox
//
//  Created by 刘海 on 2016/12/7.
//  Copyright © 2016年 刘海. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allnames:Dictionary<Int, [String]>?
    
    var allSex:NSMutableArray = [];
    
    var adHeaders:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //初始化数据，这一次数据，我们放在属性列表文件里
        self.allnames =  [
            0:[String]([
                "UILabel 标签",
                "UITextField 文本框",
                "UIButton 按钮"]),
            1:[String]([
                "UIDatePiker 日期选择器",
                "UIToolbar 工具条",
                "UITableView 表格视图"])
        ];
        
//        print(self.allnames);
        
        allSex.add(allnames as Any);
        allSex.add(allnames as Any);
        print(allSex);
        
        self.adHeaders = [
            "常见 UIKit 控件",
            "高级 UIKit 控件"
        ]
        
        for i in 0  ..< 10  {
            debugPrint(i)
        }
        
        
        
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "SwiftCell")
        
        
        //字符串转Double
        let possibleNumber:NSString = "123";
        let convertedNumber = possibleNumber.doubleValue;
        print(convertedNumber);
    }

    //在本例中，有2个分区
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    //返回表格行数（也就是返回控件数）
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = self.allnames?[section]
        return data!.count
    }
    
    // UITableViewDataSource协议中的方法，该方法的返回值决定指定分区的头部
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
            return self.adHeaders?[section]
    }
    
/*
     这是一段没用的注释
 */
//    // UITableViewDataSource协议中的方法，该方法的返回值决定指定分区的尾部
//    override func tableView(_ tableView:UITableView, titleForFooterInSection section:Int)->String? {
//        let data = self.allnames?[section]
//        return "有\(data!.count)个控件"
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0;
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            //为了提供表格显示性能，已创建完成的单元需重复使用
            let identify:String = "SwiftCell"
            //同一形式的单元格重复使用，在声明时已注册
            let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath);
            cell.accessoryType = .disclosureIndicator;
            
            let secno = indexPath.section;
            var data = self.allnames?[secno];
            cell.textLabel?.text = data![indexPath.row];
            
            return cell
    }
    
    // UITableViewDelegate 方法，处理列表项的选中事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView!.deselectRow(at: indexPath, animated: true)
        let itemString = self.allnames![indexPath.section]![indexPath.row]
        let alertController = UIAlertController(title: "提示!",
                                                message: "你选中了【\(itemString)】",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

