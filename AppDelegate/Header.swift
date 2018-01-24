
import Foundation
import UIKit
import SnapKit
import SwiftyJSON
import Kingfisher
import ObjectMapper
import Localize_Swift
import BFKit

//MARK: - ****************************** 输出方法
func print<T>(message: T,
           file: String = #file,
           method: String = #function,
           line: Int = #line){
        #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
}
//MARK: - ****************************** 方法
let iOS10                  = UIDevice.current.systemVersion >= "10.0"
let iOS11                  = UIDevice.current.systemVersion >= "11.0"
let isiPhoneX              = UIDevice().modelName == "iPhone X" || UIScreen.main.bounds.size.height == 812.0

public let SCREEN_WIDTH:CGFloat    = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT:CGFloat   = UIScreen.main.bounds.size.height
public let WIDTHPRO:CGFloat = SCREEN_WIDTH/320

let StatusBar = isiPhoneX ? 44 : 20
let TabBar    = isiPhoneX ? 49 : 73

//MARK: - ****************************** 第三方key
//let UMAppkey = ""
//let UMAppSecret = ""
//let UMessageAliasType = ""
//
////蒲公英sdk
//let PgyAppid = ""

//MARK: - ****************************** 域名
//本地测试服务器
//let port           = ""  //正式
let port           = ""//测试

//web服务器
//let webPort          = ""   //正式
let webPort          = ""  //测试

//MARK: - ****************************** 接口


//MARK: - ****************************** webUrl








