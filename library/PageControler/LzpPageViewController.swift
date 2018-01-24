//
//  LzpPageViewController.swift
//  swifttext
//
//  Created by 李子鹏 on 2017/12/20.
//  Copyright © 2017年 zdp. All rights reserved.
//

import UIKit

class LzpPageViewController: UIViewController {
    
    var pageCtr:UIPageViewController!
    var titles:[String]!
    var viewCtrs:[UIViewController]!
    var viewSegment:LzpSegmentView!
    var done:Bool = false  //翻页完成
    var currentPage:Int = 0
    
    class func initWith(titles:[String],viewCtrs:[UIViewController],parentViewController:UIViewController)->LzpPageViewController {
        let pageCtr = LzpPageViewController()
        pageCtr.titles = titles
        pageCtr.viewCtrs = viewCtrs
        
        parentViewController.addChildViewController(pageCtr)
        parentViewController.view.addSubview(pageCtr.view)
        
        return pageCtr
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        self.setUI()
        
    }
    
    func setUI(){
        viewSegment = LzpSegmentView.init(titles: self.titles)
        viewSegment.delegate = self
        self.view.addSubview(viewSegment)
        
        pageCtr = UIPageViewController.init(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        
        pageCtr.delegate = self
        pageCtr.dataSource = self
        pageCtr.view.frame = CGRect.init(x: 0, y: 44, width: view.frame.size.width, height: view.frame.size.height-44)
        
        self.addChildViewController(pageCtr)
        self.view.addSubview(pageCtr.view)
        
        pageCtr.setViewControllers([viewCtrs[0]], direction: .forward, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LzpPageViewController:UIPageViewControllerDelegate, UIPageViewControllerDataSource,UIScrollViewDelegate{
    
    //MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard  let index = viewCtrs.index(of: viewController)  else {
            return nil
        }
        
        if (index - 1) < 0{
            return nil
        }
        return viewCtrs[index-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard  let index = viewCtrs.index(of: viewController)  else {
            return nil
        }
        
        if (index + 1) >= viewCtrs.count{
            return nil
        }
        return viewCtrs[index+1]
    }
    
    //MARK: - UIPageViewControllerDelegate
    //开始翻页
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        print(message: "开始翻页")
    }
    
    //翻页完成
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        done = true
        
        guard let vc = pageViewController.viewControllers?[0],
        let index = viewCtrs.index(of: vc) else {
            return
        }
        currentPage = index
        viewSegment.setContent(offsetX: 0, index: index)
        
        print(message: "翻页完成")
    }
    
    func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: UIPageViewController) -> UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x - UIScreen.main.bounds.size.width
        print(message: "offset:\(offset)")
        
        if done == false{
//            viewSegment.setContent(offsetX: offset, index: currentPage)
        }else{
            done = false
        }
        
    }
    
    
}


extension LzpPageViewController:LzpSegmentViewDelegate{
    
    func didClick(segmentView: LzpSegmentView, index: Int) {
        if index == currentPage {
            return
        }
        weak var weakSelf = self
        self.pageCtr.setViewControllers([self.viewCtrs[index-1]], direction: .forward, animated: false) { (finish) in
            weakSelf?.currentPage = index
            weakSelf?.viewSegment.setContent(offsetX: 0, index: index-1)
        }
        
        
    }
    
}

