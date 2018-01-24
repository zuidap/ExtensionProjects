//
//  LzpSegmentView.swift
//  swifttext
//
//  Created by 李子鹏 on 2017/12/20.
//  Copyright © 2017年 zdp. All rights reserved.
//

import UIKit

protocol LzpSegmentViewDelegate {
    func didClick(segmentView:LzpSegmentView,index:Int)
}

class LzpSegmentView: UIView {
    var delegate:LzpSegmentViewDelegate?
    
    var titles:[String]!
    var maskLayer:CALayer!
    var scrollView:UIScrollView!
    var itemWidth:CGFloat!
    var lineView:UIView!
    
    init(titles:[String]) {
        let viewSize = UIScreen.main.bounds.size
        super.init(frame: CGRect.init(x: 0, y: 0, width:viewSize.width , height: 44))
        self.titles = titles
        if self.titles.count != 0{
            self.setUI()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        self.backgroundColor = UIColor.white
        
        let botLineView = UIView()
        botLineView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        botLineView.frame = CGRect.init(x: 0, y: 43.5, width: self.frame.size.width, height: 0.5)
        
        self.scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 44))
        self.scrollView.backgroundColor = UIColor.clear
        self.scrollView.isUserInteractionEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        let botView = UIView()
        botView.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 20)
        self.scrollView.addSubview(botView)
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            
        }
        self.addSubview(self.scrollView)
        self.addSubview(botLineView)
        
        if self.titlesMoreScreen(){
            self.scrollView.contentSize = CGSize.init(width: self.getAllTitlesWith(), height: 44)
        }else{
           self.scrollView.contentSize = CGSize.init(width: self.frame.size.width, height: 44)
            self.scrollView.isScrollEnabled = false
        }
        self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        
        var tampLabel:UILabel!
        
        for i in 0..<titles.count {
            let btnLabel = UILabel()
            btnLabel.tag = i+1
            btnLabel.text = titles[i]
            btnLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            btnLabel.font = UIFont.systemFont(ofSize: 16)
            btnLabel.textAlignment = .center
            btnLabel.isUserInteractionEnabled = true
            self.scrollView.addSubview(btnLabel)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.clickBtnLabel(tap:)))
            btnLabel.addGestureRecognizer(tap)
            
            if self.titlesMoreScreen(){
                let wid = self.self.getTitleWidth(title: titles[i])
                
                if i == 0{
                    btnLabel.frame = CGRect.init(x: 0, y: 0, width: wid, height: 44)
                }else{
                   let btnx = tampLabel.frame.origin.x + tampLabel.frame.size.width
                   btnLabel.frame = CGRect.init(x: btnx, y: 0, width: wid, height: 44)
                }
                
            }else{
                let wid = UIScreen.main.bounds.size.width/CGFloat(titles.count)
                btnLabel.frame = CGRect.init(x: CGFloat(i)*wid, y: 0, width: wid, height: 44)
            }
            
            tampLabel = btnLabel
            
        }
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.mainColor
        lineView.layer.cornerRadius = 1
        self.scrollView.addSubview(lineView)
        let btnLabel:UILabel = self.scrollView.viewWithTag(1) as! UILabel
        let lineFrame = btnLabel.frame
        
        lineView.frame = CGRect.init(x: lineFrame.origin.x+4, y: 44-2, width: lineFrame.size.width-8, height: 2)

    }
    
    ///点击btnlable
    @objc fileprivate func clickBtnLabel(tap:UIGestureRecognizer){
        weak var weakSelf = self
        weakSelf?.delegate?.didClick(segmentView: self, index: (tap.view?.tag)!)
        
    }
    
    ///设置指示下标位置方法
    func setContent(offsetX:CGFloat,index:Int){
        for view in self.scrollView.subviews {
            if view.isKind(of: UILabel.classForCoder()){
                (view as! UILabel).textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            }
        }
        
        let btnLabel:UILabel = self.scrollView.viewWithTag(index+1) as! UILabel
        btnLabel.textColor = UIColor.mainColor
        
        let lineFrame = btnLabel.frame
        
        let lineCenterX = btnLabel.center.x
        
        weak var weakSelf = self
        
        
        if lineCenterX - self.frame.size.width/2 < 0{
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        }else if lineCenterX + self.frame.size.width/2 > self.scrollView.contentSize.width{
            self.scrollView.setContentOffset(CGPoint.init(x: self.scrollView.contentSize.width-self.frame.size.width, y: 0), animated: false)
        }else{
            self.scrollView.setContentOffset(CGPoint.init(x: lineCenterX-self.frame.size.width/2, y: 0), animated: true)
            
        }
        
        UIView.animate(withDuration: 0.8) {
            weakSelf?.lineView.frame = CGRect.init(x: lineFrame.origin.x+4, y: 44-2, width: lineFrame.size.width-8, height: 2)
            
        }
        

        
    }
    
    
    ///计算titles是否超出屏幕宽度
    fileprivate func titlesMoreScreen()->Bool{
        let allWid:CGFloat = self.getAllTitlesWith()
        
        return (allWid > UIScreen.main.bounds.size.width) == true
    }
    
    ///获取titles总长度
    fileprivate func getAllTitlesWith()->CGFloat{
        var allWid:CGFloat = 0
        for title in titles {
            allWid = allWid + self.getTitleWidth(title: title)
        }
        return allWid
    }
    
    ///获取title长度
    fileprivate func getTitleWidth(title:String)->CGFloat{
        return self.getLabWidth(labelStr: title, font: UIFont.systemFont(ofSize: 16), height: 44) + 20
    }
    
    ///计算label长度
    fileprivate func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize.init(width: 150, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : AnyObject], context: nil).size
        
        return strSize.width
    }
    
    
}
