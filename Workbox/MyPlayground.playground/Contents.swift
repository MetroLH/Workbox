//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

//for
for i in 0 ..< 10  {
    print(i)
}


//enum
public enum testEnum : Int{
    case one = 0;
    case two;
    case three;
}


//switch
var ttt:testEnum = .two;

switch ttt {
case .one:
    print(testEnum.one)
    break;
case .two:
    print(testEnum.two)
    break;
case .three:
    print(testEnum.three);
    break;
}


public func LLog(_ items: Any...){
    print(items)
}

//GCD语法
DispatchQueue(label:"111").async {
    print("222222")
    
    LLog("1111111")
}

DispatchQueue.main.async {
    print("222")
}

var allHeaders:[String]?;
var allItems:Array<Array<Dictionary<String,String>>>?;

allHeaders = ["测量","实用工具","计算器"];
allItems = [
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

debugPrint(allItems);


20 % 10

(CGFloat(M_PI)/180.0)*20.0


String(12)

