//
//  CycleView.swift
//  swifttext
//
//  Created by zdp on 2016/9/29.
//  Copyright © 2016年 zdp. All rights reserved.
//

import UIKit
import Kingfisher
//enum HEPageControlPosition {
//    case MiddleBottom, LeftBottom, RightBottom
//    case MiddleTop,    LeftTop,    RightTop
//}
//Block
typealias BtnBlock = (Int) -> Void
//ImagesBlock
typealias ImagesBlock = () -> [String]

class CycleView: UIView,UIScrollViewDelegate {
    
    //MARK: - 私有属性
    private var btnBlock:BtnBlock?  //block
    private var imageBlock:ImagesBlock?
    
    private var scrollView: UIScrollView?
    private var pageControl: UIPageControl?
    private var images:[UIImage]?
    private var imageStrs:[String]?
    private var timer: Timer?
    private var currentPage = 0 {
        didSet {
            pageControl?.currentPage = currentPage
            resetImageViewSource()
        }
    }
    //MARK: - 给外部调用的属性
    var rollingTime: TimeInterval = 3.0   //滚动一页的时间
    var rollingEnable: Bool = true {
        //是否自动滚动
        didSet{
            if rollingEnable{
                startTimer()
            }else{
                RemoveTimer()
            }
        }
    }
    //MARK: -  刷新数据
    public func reloadCyc(){
        imageStrs = imageBlock?()
        pageControl?.numberOfPages = (imageStrs?.count)!
        
        if imageStrs?.count != 0{
            currentPage = currentPage >= imageStrs!.count ? 0 : currentPage
            if imageStrs?.count == 1{
                RemoveTimer()
                scrollView?.isScrollEnabled = false
                pageControl?.isHidden = true
            }else{
                startTimer()
                scrollView?.isScrollEnabled = true
            }
        }else{
            RemoveTimer()
            scrollView?.isScrollEnabled = false
            pageControl?.isHidden = true
            for i in 0..<3 {
                let img = scrollView?.subviews[i] as! UIImageView
                img.image = nil
            }
        }
    }
    
    
    //MAKR:- 暴露创建对象方法
    /// 获取到一个滚动视图
    ///
    /// - parameter imageSourceBlock: image数据block
    /// - parameter btnBlk:           scroview点击block
    ///
    /// - returns: CycleView对象
    static func showCycView(imageSourceBlock:ImagesBlock?,btnBlk:BtnBlock?) -> CycleView {
        let cycView = CycleView()
        cycView.showCycView(imageSourceBlock: imageSourceBlock, btnBlk: btnBlk)
        return cycView
    }
    //私有对象方法
    private func showCycView(imageSourceBlock:ImagesBlock?,btnBlk:BtnBlock?) -> Void{
        imageBlock = imageSourceBlock
        btnBlock = btnBlk
        setUI()
        self.reloadCyc()
    }
    //创建UI
    private func setUI(){
        scrollView = UIScrollView()
        self.addSubview(scrollView!)
        scrollView?.backgroundColor = UIColor.clear
        scrollView?.snp.makeConstraints({ (make) in
            make.top.left.bottom.right.equalToSuperview()
        })
        
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.isPagingEnabled = true
        scrollView?.bounces = false
        scrollView?.delegate = self
        
        scrollView?.addSubview(UIImageView())
        scrollView?.addSubview(UIImageView())
        scrollView?.addSubview(UIImageView())
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction))
        scrollView?.addGestureRecognizer(tap)
        
        pageControl?.isEnabled = false
        pageControl = UIPageControl()
        pageControl?.currentPage = 0
        pageControl?.isUserInteractionEnabled = false
        pageControl?.currentPageIndicatorTintColor = UIColor.green
        pageControl?.pageIndicatorTintColor = UIColor.gray
        self.addSubview(pageControl!)
        pageControl?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        })
    }
    //MARK:- 自动滚动
    //开始滚动
    private func startTimer() {
        if rollingEnable{//如果允许自动滚动
            if timer==nil {
                timer = Timer.scheduledTimer(timeInterval: rollingTime, target: self, selector: #selector(scrollForTime(time:)), userInfo: nil, repeats: true)
                RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
            }else{
                //延时2s执行
                //                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                self.timer?.fireDate = Date.init(timeIntervalSinceNow: rollingTime)
                //                }
            }
        }
    }
    
    //停止滚动
    private func RemoveTimer() {
        if(timer != nil){
            timer!.invalidate()
            timer = nil
        }
    }
    
    //暂停滚动
    private func stopTimer(){
        if(timer != nil){
            timer?.fireDate = Date.distantFuture
        }
    }
    
    //滚动事件
    @objc func scrollForTime(time:Timer) -> Void {
        scrollView?.setContentOffset(CGPoint(x: self.frame.size.width * 2, y: 0), animated: true)
    }
    
    //MARK:- 适配scroview及image
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView?.contentSize = CGSize(width: self.frame.size.width * 3, height: self.frame.size.height)
        scrollView?.setContentOffset(CGPoint(x: self.frame.size.width * 1, y: 0), animated: false)
        
        for i in 0..<3 {
            let img = scrollView?.subviews[i] as! UIImageView
            img.contentMode = .scaleToFill
            img.clipsToBounds = true
            img.frame = CGRect(x: CGFloat(i) * (scrollView?.frame.size.width)!, y: 0, width: (scrollView?.frame.size.width)!, height: (scrollView?.frame.size.height)!)
        }
    }
    
    //MARK:-每当滚动后重新设置各个imageView的图片
    func resetImageViewSource() {
        
        let leftImageView = scrollView?.subviews[0] as! UIImageView
        let middleImageView = scrollView?.subviews[1] as! UIImageView
        let rightImageView = scrollView?.subviews[2] as! UIImageView
        //当前显示的是第一张图片
        if currentPage == 0 {
            leftImageView.setImage(imgStr: (imageStrs?.last)!)
            middleImageView.setImage(imgStr: (imageStrs?[currentPage])!)
            let rightImageIndex = (imageStrs?.count)! > 1 ? 1 : 0 //保护
            rightImageView.setImage(imgStr: (imageStrs?[rightImageIndex])!)
            
        }//当前显示的是最后一张图片
        else if currentPage == (imageStrs?.count)! - 1 {
            leftImageView.setImage(imgStr: (imageStrs?[currentPage-1])!)
            middleImageView.setImage(imgStr: (imageStrs?[currentPage])!)
            rightImageView.setImage(imgStr: (imageStrs?[0])!)
            
        }//其他情况
        else{
            leftImageView.setImage(imgStr: (imageStrs?[currentPage-1])!)
            middleImageView.setImage(imgStr: (imageStrs?[currentPage])!)
            rightImageView.setImage(imgStr: (imageStrs?[currentPage+1])!)
            
        }
        
        scrollView?.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)//关闭动画不走代理
    }
    
    
    
    //MARK: - scrollViewDelegate
    //setContentOffset的动画完成后会调用,使currentPage+1
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if imageStrs?.count != 0{
            currentPage = (currentPage+1)%(imageStrs?.count)!
        }
    }
    //拖动scrollView时会停止自动滚动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    //拖动scrollView时当减速动画结束时调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startTimer()//拖动结束 开始自动滚动
        
        if imageStrs?.count != 0{
            if scrollView.contentOffset.x == 0 {                                    //向前滑动
                if currentPage == 0 {
                    currentPage = (imageStrs?.count)!-1
                } else {
                    currentPage -= 1
                }
            } else if scrollView.contentOffset.x == 2 * self.frame.size.width {     //向后滑动
                currentPage = (currentPage+1)%(imageStrs?.count)!
            }
        }
    }
    
    //MARK:- 点击图片回调事件
    @objc func tapAction() {
        if imageStrs?.count != 0{
            btnBlock?(currentPage)
        }
    }
    
    deinit {
        timer = nil
    }
    
    
}






