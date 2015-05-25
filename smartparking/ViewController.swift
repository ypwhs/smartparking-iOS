//
//  ViewController.swift
//  smartparking
//
//  Created by 杨培文 on 14/12/20.
//  Copyright (c) 2014年 杨培文. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var IP: UITextField!
    
    @IBOutlet weak var connButton: UIButton!
    
    @IBOutlet weak var state: UILabel!
    var client = TCPClient(addr: "192.168.8.8", port: 8080)
    
    func connect()->Bool{
        var (success,error) = client.connect(timeout: 7)
        if !success{
            println(error)
        }else {
            println("连接服务器成功")
        }
        
        return success
    }
    
    func send(buf:[UInt8]){
        let (succeed,error) = client.send(data: buf)
        if succeed{
            println("发送数据成功")
        }else{
            println("发送数据失败:\(error)")
        }
    }
    
    func read()->String{
        if let re = client.read(1024*10){
            //return re
            return NSString(bytes: re, length: re.count, encoding: NSUTF8StringEncoding) as! String
        }else{
            println("获取数据失败")
        }
        return ""
    }
    
    func xiancheng(code:dispatch_block_t){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), code)
    }
    func ui(code:dispatch_block_t){
        dispatch_async(dispatch_get_main_queue(), code)
    }
    
    func zhongjian(str:String,str1:String,str2:String)->String {
        var left = str.rangeOfString(str1)
        var right = str.rangeOfString(str2)
        var r = Range(start: (left?.endIndex)! , end: (right?.startIndex)!)
        var s = str.substringWithRange(r)
        return s
    }

    
    @IBOutlet weak var oneText: UILabel!
    @IBOutlet weak var twoText: UILabel!

    @IBOutlet weak var sugText: UILabel!
    var carCM = [8.1, 8.2, 8.3]
    
    @IBAction func conn(sender: AnyObject) {
        client = TCPClient(addr: IP.text, port: 8080)
        if connect(){
            state.text = "连接成功"
            connButton.enabled = false
            
            xiancheng({
                while true{
                    var str = self.read()
                    //[1]1.23cm
                    println(str)
                    
                    var num = self.zhongjian(str, str1: "[", str2: "]").toInt()!
                    var cm = (self.zhongjian(str, str1: "]", str2: "cm") as NSString).doubleValue
                    self.carCM[num] = cm
                    var text = "\(num)号车位\n"
                    var text2 = "建议停车位：\n1号车位"
                    if cm < 7{
                        text += "有车\n"
                    }else {
                        text += "无车\n"
                    }
                    text += "\(cm)cm"

                    println(text)
                    if self.carCM[1] < 7{
                        text2 = "建议停车位：\n2号车位"
                        if self.carCM[2] < 7{
                            text2 = "建议停车位：\n无"
                        }
                    }
                    
                    self.ui({
                        if num == 1{
                            self.oneText.text = text
                        }else if num == 2{
                            self.twoText.text = text
                        }
                        self.sugText.text = text2
                    })
                    
                }
            })
            
        }else{
            state.text = "连接失败"
        }
    }
}

