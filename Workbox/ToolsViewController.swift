//
//  ToolsViewController.swift
//  Workbox
//
//  Created by 刘海 on 2016/12/12.
//  Copyright © 2016年 刘海. All rights reserved.
//

import UIKit

class ToolsViewController: UITableViewController {
    
    var allHeaders:[String]?;
    
    var allItems:Array<Array<Dictionary<String,String>>>?;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //初始化工具栏
        
        self.allHeaders = ["测量","实用工具","常用计算器"];
        self.allItems = [
            [
                ["image":"","name":"直尺","explain":"直尺"],
                ["image":"","name":"量角器","explain":"量角器"],
                ],
            [
                ["image":"","name":"手电筒","explain":"手电筒"],
                ["image":"","name":"镜子","explain":"镜子"],
                ],
            [
                ["image":"","name":"计算器","explain":"计算器"],
                ["image":"","name":"汇率转换","explain":"汇率转换"],
                ],
        ];
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.tintColor = Color(red: 22, green: 22, blue: 22, alpha: 1);
    }
    
//    //TableView 分区
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return self.allHeaders!.count;
//    }
//    
//    //返回表格行数（也就是返回控件数）
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let item = self.allItems?[section];
//        return (item?.count)!;
//    }
//    
//    // UITableViewDataSource协议中的方法，该方法的返回值决定指定分区的头部
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
//        -> String? {
//            return self.allHeaders?[section];
//    }
//    
//    //创建各单元显示内容(创建参数indexPath指定的单元）
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
//        -> UITableViewCell {
//            
//            //为了提供表格显示性能，已创建完成的单元需重复使用
//            let identify:String = "ToolsTBCell"
//            //同一形式的单元格重复使用，在声明时已注册
//            let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath) as! ToolsTableViewCell;
////            cell.accessoryType = .disclosureIndicator;
//            
//            var data = self.allItems?[indexPath.section][indexPath.row];
//            
//            cell.nameLabel?.text = data?["name"];
//            cell.helpLabel?.text = data?["explain"];
//            
//            return cell
//    }
//    
    // UITableViewDelegate 方法，处理列表项的选中事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView!.deselectRow(at: indexPath, animated: true)
        
//        let itemString = self.allItems?[indexPath.section][indexPath.row]["name"];
//        let alertController = UIAlertController(title: "提示!",
//                                                message: "你选中了【\(itemString)】",
//            preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
        
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
