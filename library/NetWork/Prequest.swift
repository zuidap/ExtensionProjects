//
//  Prequest.swift
//  swifttext
//
//  Created by zdp on 16/9/19.
//  Copyright © 2016年 zdp. All rights reserved.
//

import UIKit
import Alamofire
import Reachability
public typealias CompletionBlock = (AnyObject?) -> ()
public typealias FailureBlock = (AnyObject?) -> ()

let manager = NetworkReachabilityManager()
class Prequest: NSObject {
    
    //网络检测
    
    static func netWorkReachabilit(){
        
        manager!.listener = { status in
            
            switch status {
            case .notReachable:
                print(message:"无网络")
                UIViewController.currentViewController()?.view.show(error: "无网络连接，请前往设置")
                UserDefaults.standard.set(false, forKey: "netWorkState")
            case .unknown:
                print(message:"未知")
                UserDefaults.standard.set(false, forKey: "netWorkState")
            case .reachable(.ethernetOrWiFi):
                print(message:"WiFi")
                UserDefaults.standard.set(true, forKey: "netWorkState")
            case .reachable(.wwan):
                print(message:"手机流量")
                UserDefaults.standard.set(true, forKey: "netWorkState")
            }
        }
        manager!.startListening()
        
    }
    
    /**
     *  请求 JSON
     *
     *  @param method        HTTP 请求方法
     *  @param URLString     URL字符串
     *  @param parameters    参数字典
     *  @param completion    完成回调，返回NetworkResponse
     */
    class func requestJSON(outTime:TimeInterval = 10,method: HTTPMethod,
                           URLString: String,
                           parameters: [String: Any]? = nil,
                           completion:  CompletionBlock?,
                           failure: FailureBlock?) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIViewController.currentViewController()?.view.showActivity()
        
        let usrStr = URLString
       
        print(message: usrStr)
        let alamoFireManager = SessionManager.default
        var request = URLRequest.init(url: URL.init(string: usrStr)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = outTime //
        
        if parameters != nil{
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: [])
            }catch{
                UIViewController.currentViewController()?.view.hidenActivity()
                UIViewController.currentViewController()?.view.show(error: "请求错误")
                return
            }
            
        }
        
        alamoFireManager.request(request).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
               UIViewController.currentViewController()?.view.hidenActivity()
                
                completion?(value as AnyObject?)
                
            case .failure(let error):
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                failure?(error as AnyObject?)
               UIViewController.currentViewController()?.view.hidenActivity()
            }
        }
        
    }
    
    /////
    class func upImage(method: HTTPMethod,
                       URLString: String,
                       parameters: [String: String]? = nil,
                       image:UIImage,
                       completion:  CompletionBlock?,
                       failure: FailureBlock?){
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            var data = UIImagePNGRepresentation(image)
            
            if data == nil{
                data = UIImageJPEGRepresentation(image, 1.0);
            }
            let imageName = String(describing: NSDate.init()) + ".png"
            
            multipartFormData.append(data!, withName: "file", fileName: imageName, mimeType: "image/png")
            
            //遍历字典
            for (key, value) in parameters!{
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to: URLString) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON(completionHandler: { (response) in
                    
                    switch response.result{
                        
                    case .success(let value):
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        completion?(value as AnyObject?)
                        
                    case .failure(let error):
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        failure?(error as AnyObject?)
                    }
                })
                
            case .failure(let error):
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                failure?(error as AnyObject?)
            }
            
        }
        
        
    }
    
    
    //生成token
//    class func creatToken() ->String{
//        let now = NSDate()
//        // 创建一个日期格式器
//        let dformatter = DateFormatter()
//        dformatter.dateFormat = "yyyyMMdd"
//        print(message:"当前日期时间：\(dformatter.string(from: now as Date))")
//
//        let appId = "1234"
//        let appSecret = "oainterfaceej55pu4qjjyir"
//        let timeStamp = dformatter.string(from: now as Date)
//        let jsonStr = appId + appSecret + timeStamp
//        print(message: jsonStr)
//
//        let appSignature = DesEncrypt.encryptPassword(encryptData:jsonStr as String, key: desAppKey)
//
//        return appSignature
//
//    }
    
    
    
}





