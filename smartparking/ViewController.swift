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

    

    @IBAction func conn(sender: AnyObject) {
        client = TCPClient(addr: IP.text, port: 8080)
        if connect(){
            state.text = "连接成功"
            connButton.enabled = false
            
            xiancheng({
                while true{
                    var str = self.read()
                    //[1]1.23cm
                    var num = self.zhongjian(str, str1: "[", str2: "]").toInt()
                    var cm = (self.zhongjian(str, str1: "]", str2: "cm") as NSString).floatValue
                    println("num:\(num),cm:\(cm)")
                }
            })
            
        }else{
            state.text = "连接失败"
        }
    }
}

