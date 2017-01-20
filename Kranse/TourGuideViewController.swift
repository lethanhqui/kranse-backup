//
//  TourGuideViewController.swift
//  Kranse
//
//  Created by macbook on 9/19/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
class TourGuideViewController: UIViewController, UIPageViewControllerDataSource ,UIPageViewControllerDelegate , GuideViewDelegate{
    var pageController:UIPageViewController?
    
    @IBOutlet weak var pageControl: UIPageControl!
    var page : UIPageControl!
    @IBOutlet weak var btnNext: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initPageViewController()
    }
    //MARK - Init
    func initPageViewController(){
//    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        self.pageController = UIPageViewController.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageController?.dataSource = self;
        self.pageController?.delegate = self
        self.pageController?.view.frame = self.view.bounds
        
        let initialViewController = self.viewControllerAtIndex(0)
        
        let viewControllers : [UIViewController] = [initialViewController!]
        
        self.pageController?.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
        self.addChildViewController(self.pageController!)
        self.view.addSubview((self.pageController?.view)!)
        self.pageController?.didMoveToParentViewController(self)
        //
        self.view.bringSubviewToFront(self.btnNext)
        pageControl.backgroundColor = UIColor.clearColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        pageControl.pageIndicatorTintColor = UIColor.blueColor()
        pageControl.hidden = true
        self.page = UIPageControl(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.width, 30))
        self.page.center = self.view.center
        self.page.frame = CGRectMake(self.page.frame.origin.x, UIScreen.mainScreen().bounds.height - 45, self.page.frame.width, self.page.frame.height)
        self.view.addSubview(page)
        page.currentPageIndicatorTintColor = UIColor.redColor()
        page.pageIndicatorTintColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        page.numberOfPages = 3
        page.backgroundColor = UIColor.clearColor()
    }

    //MARK - PageViewController
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let guideVC = viewController as? GuideViewController else {return nil}
        var index : Int = guideVC.index!
        index = index + 1
        if index == 3 {
            return nil
        }
        return viewControllerAtIndex(index)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

        guard let guideVC = viewController as? GuideViewController else {return nil}
        var index : Int = guideVC.index!
        if index == 0 {
            return nil
        }
        index = index - 1
        return viewControllerAtIndex(index)
    }
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        guard let guide = pageViewController.viewControllers![0] as? GuideViewController else {return}
        page.currentPage = guide.index!
        
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    func viewControllerAtIndex(index : Int) -> GuideViewController?{
        let storyboard = UIStoryboard.init(name: "Guide", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("guideViewController") as? GuideViewController
        vc?.index = index
        vc?.delegate = self
        return vc;
    }
    @IBAction func pressedNext(sender: AnyObject) {
        gotoNextPage()
    }
    
    //MArk - GuideViewDelegate
    func didNextGuideViewAtIndex(index: Int) {
        gotoNextPage()
    }
    
    //Mark
    func gotoNextPage(){
        let curIndex = page.currentPage
        if curIndex < 2 {
            let nextIndex = curIndex + 1
            page.currentPage = nextIndex
            self.pageController?.setViewControllers([self .viewControllerAtIndex(nextIndex)!], direction: .Forward, animated: true, completion: nil)

        }else{
           //setLoginToVRootViewController
            let storyboard = UIStoryboard(name: "Guide", bundle: nil)
            let homeController = storyboard.instantiateViewControllerWithIdentifier("homeViewController")
            
//            guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {return}
//            let navigator = UINavigationController.init(rootViewController: rootController)
//            appDelegate.window?.rootViewController = navigator
//            appDelegate.window?.makeKeyAndVisible()

            self.navigationController?.pushViewController(homeController, animated: true)
        }
    }
    
    
    func setRootViewController(){
        let storyboard = UIStoryboard(name: "Guide", bundle: nil)
        let rootController = storyboard.instantiateViewControllerWithIdentifier("loginViewController")
        
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {return}
        
        appDelegate.window?.rootViewController = rootController
        appDelegate.window?.makeKeyAndVisible()

    }
}