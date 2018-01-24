

import UIKit
import Foundation

//MARK: -scrollViewDelegate,tableViewDelegate,collectionViewDelegate
protocol scrollViewDelegate:UIScrollViewDelegate {}

protocol tableViewDelegate:UITableViewDelegate,UITableViewDataSource {}

protocol collectionViewDelegate:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {}

//自定义协议 继承协议 调用 loadFromNib方法
protocol NibLoadable {}

//MARK: -
extension UIViewController {
    /// 弹出UIAlertController
    public func show(title: String?, message: String, actions: [UIAlertAction], alertType: UIAlertControllerStyle = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertType)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 获取当前显示的viewcontroller
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}

//MARK: -

extension UIView {
    //x
    var z_x: CGFloat {
        get {
            return frame.origin.x
        }
        set{
            var tempFrame: CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    // y
    
    var z_y: CGFloat {
        set {
            var tempFrame: CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
        get {
            return frame.origin.y
            
        }
        
    }
    
    // height
    var z_height : CGFloat {
        get {
            return frame.size.height
        }
        
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.height  = newVal
            frame                 = tmpFrame
        }
    }
    
    // width
    var z_width : CGFloat {
        get {
            return frame.size.width
        }
        
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.width   = newVal
            frame                 = tmpFrame
        }
    }
    
    // left
    var z_left : CGFloat {
        get {
            return z_x
        }
        
        set(newVal) {
            z_x = newVal
        }
    }
    
    // right
    var z_right : CGFloat {
        get {
            return z_x + z_width
        }
        
        set(newVal) {
            z_x = newVal - z_width
        }
    }
    
    // bottom
    var z_bottom : CGFloat {
        get {
            return z_y + z_height
        }
        
        set(newVal) {
            z_y = newVal - z_height
        }
    }
    
    
    //自身中心点
    var z_center: CGPoint {
        
        get {
            return CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        }
        set {
            center = CGPoint(x: newValue.x, y: newValue.y)
        }
        
    }
    
    //中心点x
    var z_centerX : CGFloat {
        get {
            return center.x
        }
        
        set(newVal) {
            center = CGPoint(x: newVal, y: center.y)
        }
    }
    //中心点y
    var z_centerY : CGFloat {
        get {
            return center.y
        }
        
        set(newVal) {
            center = CGPoint(x: center.x, y: newVal)
        }
    }
    ///增加是否在当前显示的窗口
    public func isShowingnKeyWindow() -> Bool {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return false
        }
        //以主窗口的左上角为原点, 计算self的矩形框(谁调用这个方法这个self就是谁)
        let frame = keyWindow.convert(self.frame, from: self.superview)
        //判断主窗口的bounds和self的范围是否有重叠
        let isIntersects = frame.intersects(keyWindow.bounds)
        return isIntersects && !self.isHidden && self.alpha > 0 && self.window == keyWindow
    }
    
    ///抖动方向枚举
    public enum ShakeDirection: Int {
        case horizontal  //水平抖动
        case vertical  //垂直抖动
    }
    /**
     扩展UIView增加抖动方法
     @param direction：抖动方向（默认是水平方向）
     @param times：抖动次数（默认5次）
     @param interval：每次抖动时间（默认0.1秒）
     @param delta：抖动偏移量（默认2）
     @param completion：抖动动画结束后的回调
     */
    public func shake(direction: ShakeDirection = .horizontal, times: Int = 5,
                      interval: TimeInterval = 0.1, delta: CGFloat = 2,
                      completion: (() -> Void)? = nil) {
        //播放动画
        UIView.animate(withDuration: interval, animations: { () -> Void in
            switch direction {
            case .horizontal:
                self.layer.setAffineTransform( CGAffineTransform(translationX: delta, y: 0))
                break
            case .vertical:
                self.layer.setAffineTransform( CGAffineTransform(translationX: 0, y: delta))
                break
            }
        }) { (complete) -> Void in
            //如果当前是最后一次抖动，则将位置还原，并调用完成回调函数
            if (times == 0) {
                UIView.animate(withDuration: interval, animations: { () -> Void in
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (complete) -> Void in
                    completion?()
                })
            }
                //如果当前不是最后一次抖动，则继续播放动画（总次数减1，偏移位置变成相反的）
            else {
                self.shake(direction: direction, times: times - 1,  interval: interval,
                           delta: delta * -1, completion:completion)
            }
        }
    }
    
}

//MARK: -
extension NibLoadable where Self : UIView {
    //在协议里面不允许定义class 只能定义static
    static func loadFromNib(_ nibname: String? = nil) -> Self {//Self (大写) 当前类对象
        //self(小写) 当前对象
        let loadName = nibname == nil ? "\(self)" : nibname!
        
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}


//MARK: -
extension UITableView{
    ///创建一个tableView
    convenience init(style:UITableViewStyle = .plain,target:tableViewDelegate){
        self.init(frame: CGRect.zero, style: style)
        self.backgroundColor = UIColor.groupTableViewBackground
        self.tableFooterView = UIView()
        self.delegate = target
        self.dataSource = target
        //self = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)//分割线位置
        //self?.separatorStyle = .none //设置cell 下边线类型
        self.separatorStyle = .none
        self.estimatedRowHeight = 45
        self.rowHeight = UITableViewAutomaticDimension
    }
}

//MARK: -
extension UICollectionView{
    convenience init(layout:UICollectionViewFlowLayout? = nil,direction:UICollectionViewScrollDirection = .vertical,target:collectionViewDelegate){
        var layout = layout
        if layout == nil{
            layout = UICollectionViewFlowLayout()
            //layout?.minimumLineSpacing = 1
            //layout?.minimumInteritemSpacing = 10
            //layout?.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5);
            layout?.scrollDirection = direction
        }
        self.init(frame: CGRect.zero, collectionViewLayout: layout!)
        self.backgroundColor = UIColor.groupTableViewBackground
        self.delegate = target
        self.dataSource = target
    }
}

//MARK: -
extension UIScrollView{
    //
     convenience init(contentSize: CGSize, clipsToBounds: Bool=false, pagingEnabled:Bool=false, showScrollIndicators: Bool, delegate: scrollViewDelegate?=nil) {
        self.init(frame: CGRect.zero)
        self.delegate = delegate
        self.isPagingEnabled = pagingEnabled
        self.clipsToBounds = clipsToBounds
        self.showsVerticalScrollIndicator = showScrollIndicators
        self.showsHorizontalScrollIndicator = showScrollIndicators
        self.isScrollEnabled = true
        self.bounces = false
        self.contentSize = contentSize
    }
    
    convenience init(target:scrollViewDelegate?){
        self.init()
        self.delegate = target
        self.backgroundColor = UIColor.groupTableViewBackground
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = true
        self.isPagingEnabled = true
        self.bounces = false
        
        //使它能够在设备旋转之后自动适应新的宽度和高度
        self.autoresizingMask = [UIViewAutoresizing.flexibleWidth,UIViewAutoresizing.flexibleHeight]
        self.minimumZoomScale = 0.1
        self.maximumZoomScale = 4.0
        self.zoomScale = 1.0
        //scrollView.minimumZoomScale = max(1, 3)
    }
    
}

//MARK: -
extension UIPageControl{
    convenience init(target:AnyObject?,action:Selector?){
        self.init()
        self.isEnabled = true
        self.currentPage = 0
        self.isUserInteractionEnabled = true
        self.currentPageIndicatorTintColor = UIColor.green
        self.pageIndicatorTintColor = UIColor.gray
        if action != nil{
            self.addTarget(target, action: action!, for: UIControlEvents.valueChanged)
        }
    }
}
//MARK: -
extension UIImageView {
    /// 为imageView安全赋图
    func setHeaderImage(_ imageUrl: String) -> Void {
        guard let url =  URL(string: imageUrl)  else {
            return
        }
        kf.setImage(with: url, placeholder: UIImage(named: "placeholder")) { (image, error, cache, url) in
            
            if image != nil {
                self.image = image?.cicleImage()
                
            }
        }
    }
    
    /// 判断本地或者网络然后赋值
    func setImage(imgStr:String){
        if imgStr.isUrl(){
            self.kf.setImage(with: URL.init(string: imgStr), placeholder: UIImage.init(named: "placeholder"))
        }else{
            self.image = UIImage.init(named: imgStr)
        }
    }
}
//MARK: -
extension UIImage {
    /// 获得圆图
    ///
    /// - Returns: cicleImage
    public func cicleImage() -> UIImage {
        
        // 开启图形上下文 false代表透明
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        // 获取上下文
        let ctx = UIGraphicsGetCurrentContext()
        // 添加一个圆
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        ctx?.addEllipse(in: rect)
        // 裁剪
        ctx?.clip()
        // 将图片画上去
        draw(in: rect)
        // 获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

//MARK: -
extension UIBarButtonItem{
    convenience init(title:String,fontSize:CGFloat = 16,target:AnyObject,action:Selector) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.orange, for: .highlighted)
        btn.addTarget(target, action: action, for: .touchUpInside)
        //实例化 UIBarButtonItem
        self.init(customView:btn)
        
    }
}

//MARK: -
extension UIButton{
    convenience init(type:UIButtonType = .roundedRect,tag:Int = 0,font:UIFont = UIFont.CustomFont(),title:String?,titleColor:UIColor = UIColor.black,image:String?,target:AnyObject,action:Selector){
        self.init(type: type)
        self.tag = tag
        self.titleLabel?.font = font
        self.setTitle(title, for: UIControlState.normal)
        self.setTitleColor(titleColor, for: UIControlState.normal)
        self.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        if image != nil{
            self.setImage(UIImage.init(named: image!), for: UIControlState.normal)
        }
    }
}

//MARK: -
extension UITextField{
    ///创建一个UITextField
    convenience init(font:UIFont = UIFont.CustomFont(),textAlignment:NSTextAlignment=NSTextAlignment.left,Placeholder:String = "",secureTextEntry:Bool=false){
        self.init()
        self.font = font
        self.textAlignment = textAlignment
        self.placeholder = Placeholder
        self.isSecureTextEntry = secureTextEntry
        self.clearButtonMode = UITextFieldViewMode.always
        self.leftViewMode = .always
    }
}

//MARK: -
extension UILabel{
    ///创建一个UILabel
    convenience init(font:UIFont = UIFont.CustomFont(),textColor:UIColor = UIColor.black,textAlignment:NSTextAlignment = NSTextAlignment.left,text:String = "") {
        self.init()
        self.font = font;
        self.textColor = textColor;
        self.textAlignment = textAlignment
        self.text = text
    }
}

//MARK: -
extension UIFont{
    static let maxFont    = UIFont.systemFont(ofSize: 18)
    static let mediumFont = UIFont.systemFont(ofSize: 16)
    static let minFont    = UIFont.systemFont(ofSize: 14)
    /// 默认字体
    class func CustomFont(size:CGFloat = 16) ->UIFont{
        let font = UIFont.systemFont(ofSize: size)
        return font
    }
}

//MARK: -
extension UIColor{
    
    static let mainColor = UIColor.init(str: 0xEF7EB0)
    static let viceColor = UIColor.init(str: 0xEFAF01)
    
    static let tableBgColor = UIColor.init(str: 0xF5F5F5)
    static let tableSeparatorColor = UIColor.init(str: 0xE2E2E2)
    static let tableSectionColor =  UIColor.init(str: 0xF2F2F2)
    
    /// 获取一个rgb颜色
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,l:CGFloat = 1){
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: l)
    }
    
    /// 初始化一个16进制颜色
    convenience init(str:Int,l:CGFloat = 1) {
        //[self.tabBar setTintColor:[UIColor getColor:0x535353]];//用法
        self.init(red:CGFloat((str & 0xFF0000) >> 16) / 255.0,green: CGFloat((str & 0x00FF00) >> 8) / 255.0,blue: CGFloat(str & 0x0000FF) / 255.0,alpha: CGFloat(l))
    }
}

//MARK: -
public extension UIDevice {
    ///获取设备名称
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":                                           return "iPod Touch 1"
        case "iPod2,1":                                           return "iPod Touch 2"
        case "iPod3,1":                                           return "iPod Touch 3"
        case "iPod4,1":                                           return "iPod Touch 4"
        case "iPod5,1":                                           return "iPod Touch (5 Gen)"
        case "iPod7,1":                                           return "iPod Touch 6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":               return "iPhone 4"
        case "iPhone4,1":                                         return "iPhone 4s"
        case "iPhone5,1":                                         return "iPhone 5"
        case "iPhone5,2":                                         return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":                                         return "iPhone 5c (GSM)"
        case "iPhone5,4":                                         return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":                                         return "iPhone 5s (GSM)"
        case "iPhone6,2":                                         return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":                                         return "iPhone 6"
        case "iPhone7,1":                                         return "iPhone 6 Plus"
        case "iPhone8,1":                                         return "iPhone 6s"
        case "iPhone8,2":                                         return "iPhone 6s Plus"
        case "iPhone8,4":                                         return "iPhone SE"
        case "iPhone9,1":                                         return "国行、日版、港行iPhone 7"
        case "iPhone9,2":                                         return "港行、国行iPhone 7 Plus"
        case "iPhone9,3":                                         return "美版、台版iPhone 7"
        case "iPhone9,4":                                         return "美版、台版iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":                           return "iPhone 8"
        case "iPhone10,2","iPhone10,5":                           return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":                           return "iPhone X"
            
        case "iPad1,1":                                           return "iPad"
        case "iPad1,2":                                           return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":          return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":                     return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":                     return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":                     return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":                     return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":                     return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":                     return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                                return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":                                return "iPad Air 2"
        case "iPad6,3", "iPad6,4":                                return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":                                return "iPad Pro 12.9"
        case "AppleTV2,1":                                        return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":                           return "Apple TV 3"
        case "AppleTV5,3":                                        return "Apple TV 4"
        case "i386", "x86_64":                                    return "Simulator"
        default:  return identifier
        
        }
    }
}

//MARK: -
extension String {
    
    /// 验证URL格式是否正确
     func isUrl() -> Bool {
        // 创建一个正则表达式对象
        do {
            let dataDetector = try NSDataDetector(types:
                NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue))
            // 匹配字符串，返回结果集
            let res = dataDetector .matches(in: self,
                                            options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                            range: NSMakeRange(0, self.count))
            // 判断结果(完全匹配)
            if res.count == 1  && res[0].range.location == 0
                && res[0].range.length == self.count {
                return true
            }
        }
        catch {
            print(error)
        }
        return false
    }
    
        /// 获取高度计算
        public func height(_ size: CGSize, _ attributes: [NSAttributedStringKey: Any]?) -> CGFloat {
            
            let string = self as NSString
            
            let stringSize = string.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return stringSize.height
            
        }
        /// 获取宽度计算
        public func width(_ size: CGSize, _ attributes: [NSAttributedStringKey: Any]?) -> CGFloat {
            
            let string = self as NSString
            
            let stringSize = string.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return stringSize.width
            
        }
    
    ///MD5加密
    var md5Str: String {
        let cStr = self.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    /// 判断是否是手机号
//    var isPhoneNum: Bool{
//        let str1 = self as NSString
//        return str1.isElevenDigitNum()
//    }
}

//MARK: -
extension Date {
    /// 时间差
    ///
    /// - Parameter fromDate: 起始时间
    /// - Returns: 对象
    public func daltaFrom(_ fromDate: Date) -> DateComponents {
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        return calendar.dateComponents(components, from: fromDate, to: self)
    }
    
    /// 是否是同一年
    ///
    /// - Returns: ture or false
    func isThisYear() -> Bool {
        let calendar = Calendar.current
        let currendarYear = calendar.component(.year, from: Date())
        let selfYear =  calendar.component(.year, from: self)
        return currendarYear == selfYear
    }
    
    /// 是否是今天的时间
    ///
    /// - Returns: Bool
    public func isToday() -> Bool{
        
        let currentTime = Date().timeIntervalSince1970
        
        let selfTime = self.timeIntervalSince1970
        
        return (currentTime - selfTime) <= (24 * 60 * 60)
    }
    
    /// 是否是昨天的时间
    ///
    /// - Returns: Bool
    public func isYesToday() -> Bool {
        
        let currentTime = Date().timeIntervalSince1970
        
        let selfTime = self.timeIntervalSince1970
        
        return (currentTime - selfTime) > (24 * 60 * 60)
    }
    
}




