//
//  ToastHud.swift
//  Holdoll
//
//  Created by 李子鹏 on 2018/1/17.
//  Copyright © 2018年 zdp. All rights reserved.
//

import UIKit
import Toast_Swift
extension UIView{
    
    /// 等待旋转图
    ///
    /// - Parameter state:
    func show(state:String){
        self.makeToast(state)
        
    }
    
    
    /// 错误提示
    ///
    /// - Parameter error: <#error description#>
    func show(error:String){
        let point = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.makeToast(error, duration: 2.0, point: point, title: "", image: nil, style: ToastStyle(), completion: nil)
        
    }
    
    /// 成功提示
    ///
    /// - Parameter success: <#success description#>
    func show(success:String){
        
        let point = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.makeToast(success, duration: 2.0, point: point, title: "", image: nil, style: ToastStyle(), completion: nil)
        
    }
    
    
    /// 等待hud
    func showActivity(){
        
        let point = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.makeToastActivity(point)
        
    }
    
    /// 隐藏等待hud
    func hidenActivity(){
        self.hideToastActivity()
        
    }
    
    
    
    
    
    
    
    
}
