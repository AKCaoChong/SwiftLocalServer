//
//  ViewController.swift
//  SwiftLocalServer
//
//  Created by thundersoft on 2018/3/8.
//  Copyright © 2018年 thundersoft. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let startBtn = UIButton.init(frame: CGRect.init(x: 30, y: 100, width: 100, height: 50))
        startBtn.addTarget(self, action: #selector(startServer), for: .touchUpInside)
        startBtn.setTitle("开始请求", for: .normal)
        startBtn.titleLabel?.text = "开始请求"
        startBtn.backgroundColor = UIColor.blue
        self.view.addSubview(startBtn)
        
        self.imageView = UIImageView.init(frame: CGRect.init(x: 30, y: 200, width: 100, height: 100))
        self.view.addSubview(self.imageView)
        
    }
    
    @objc func startServer() {
        Alamofire.request("http://localhost:35731/upload",method:.post,parameters: nil).response(completionHandler: { (result) in
            let str = String.init(data: result.data!, encoding: .utf8)
            print(result.data)
            print(str)
            self.imageView.image = UIImage.init(data: result.data!)
        })
    }
    
    //另一个APP启动服务
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        Alamofire.request("http://localhost:35731/people",method:.get,parameters: nil).response(completionHandler: { (result) in
            let str = String.init(data: result.data!, encoding: .utf8)
            print(result.data)
            print(str)
            if  result.response?.statusCode  != 200
            {
                return
            }else{
                let dic = self.dataToDictionary(data: result.data!)
                print("\(dic)")
            }
        })
        
    }
    
    func dataToDictionary(data: Data) -> Dictionary<String, Any>? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dic = json as! Dictionary<String, Any>
            return dic
        } catch _ {
            print("失败")
            return nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension ViewController: CLLocationManagerDelegate{
    
   
    
    
    
}


class HTTPHelper : NSObject{
    
    class func ipAddress() -> String? {
        var addresses = [String]()
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }
}

