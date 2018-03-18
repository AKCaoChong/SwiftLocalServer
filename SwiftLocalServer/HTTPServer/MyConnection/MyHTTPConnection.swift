//
//  MyHTTPConnection.swift
//  SwiftLocalServer
//
//  Created by thundersoft on 2018/3/12.
//  Copyright © 2018年 thundersoft. All rights reserved.
//

import UIKit

class MyHTTPConnection: HTTPConnection {

    //默认的请求方法是get 这里如果是post也通过
    override func supportsMethod(_ method: String!, atPath path: String!) -> Bool {
        if method == "POST" {
            return true
        }
        return super.supportsMethod(method, atPath: path)
    }
    
    override func expectsRequestBody(fromMethod method: String!, atPath path: String!) -> Bool {
        print("00000000000000000")
        return super.expectsRequestBody(fromMethod: method, atPath: path)
    }
    
    
    override func httpResponse(forMethod method: String!, uri path: String!) -> (NSObjectProtocol & HTTPResponse)! {
        if method == "POST" && path.hasPrefix("/upload") {
            return HTTPFileResponse.init(filePath: Bundle.main.path(forResource: "wifi", ofType: "png"), for: self)
        }else if method == "GET" && path.hasPrefix("/people") {
            print("请求路径:  \(path)")
            let dic:[String: Any] = ["data": ["name":"helloworld","age":18,"agent":"woman"]]
            
            return HTTPDataResponse.init(data: self.jsonToData(jsonDic: dic))
        }else {
            return super.httpResponse(forMethod: method, uri: path)
        }
    }
    
    func jsonToData(jsonDic: Dictionary<String,Any>) -> Data? {
        if !(JSONSerialization.isValidJSONObject(jsonDic)) {
            print("is not a valid json object")
            return nil
        }
        //利用自带的json库转成data
        //如果设置options为JSONSerialization。writingOptions.prettyPrinted 则打印格式更好阅读
        let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        //data 转成string打印输出
        let str = String.init(data: data!, encoding: .utf8)
        print("Json str: \(str!)")
        return data
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
    
}


















