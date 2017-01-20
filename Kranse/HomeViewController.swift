//
//  HomeViewController.swift
//  Kranse
//
//  Created by macbook on 9/20/16.
//  Copyright © 2016 itv. All rights reserved.
//
//[10/27/16, 1:36:44 PM] ITV_Vo Cao Thuy Linh: 1046
//[10/27/16, 1:36:58 PM] ITV_Vo Cao Thuy Linh: shahidi
import Foundation
let segueScholaship     = "segueScholarship"
let segueLogin          = "segueLogin"
let segueRegister       = "registerSegue"
let seguePreSat         = "prepsatSegue"
class HomeViewController: BaseViewController {
    @IBOutlet weak var btnPrefSAT: UIButton!
    
    @IBOutlet weak var btnScholarship: UIButton!
    
    @IBOutlet weak var btnSubmitReview: UIButton!
    
    @IBOutlet weak var lbTitlePref: UILabel!

    @IBOutlet weak var lbTitleScholarship: UILabel!
    
    @IBOutlet weak var lbTitleReview: UILabel!
    var titleFont: UIFont?

    @IBOutlet weak var menuIconWidth: NSLayoutConstraint!
    @IBOutlet weak var menuIconPading: NSLayoutConstraint!
    
    @IBOutlet weak var middleTopMargin: NSLayoutConstraint!
    
    @IBOutlet weak var middleBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var menuTopMargin: NSLayoutConstraint!
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var imvLogin: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var registerMarginBottom: NSLayoutConstraint!
    var toView:DestinationView = DestinationView.Schalarship
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnBack.imageView?.contentMode = .ScaleAspectFit
        self.btnBack.hidden = AppRuntime.sharedInstance.isFirstTime()
        self.btnBack.addTarget(self, action: #selector(pressedBack(_:)), forControlEvents: .TouchUpInside)
        
        AppRuntime.sharedInstance.setFristTime()
        setupViews()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        layoutForLoginSate()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == seguePreSat{
            guard let webview = segue.destinationViewController as? KranseWebviewController else {return}
            webview.addressType = AddressType.PrepForTheSat.rawValue
        }else if segue.identifier == segueRegister{
            let webview = segue.destinationViewController as? KranseWebviewController
            webview?.addressType = AddressType.Register.rawValue
        }else if segue.identifier == segueLogin{
            if let login = segue.destinationViewController as? LoginViewController{
                login.toView = toView
            }
        }
    }
    func setupViews(){
        
        
        self.btnSubmitReview.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping;
         self.btnSubmitReview.titleLabel?.textAlignment = NSTextAlignment.Left; // if you want to
        self.btnSubmitReview.titleLabel?.numberOfLines = 2
        self.btnSubmitReview.setTitle("Submit a Review \nand Receive a Gift", forState: UIControlState.Normal)
        
        if UIDevice.currentDevice().modelName.containsString("iPhone 5") || UIScreen.mainScreen().bounds.size.height == 568.0{
            lbTitle.font = lbTitle.font.fontWithSize(25)
            titleFont = lbTitlePref.font.fontWithSize(12)
            lbTitlePref.font = titleFont;
            lbTitleScholarship.font = titleFont;
            lbTitleReview.font = titleFont;
            menuIconPading.constant = 10
            menuIconWidth.constant = 50
            middleTopMargin.constant = 30
            middleBottomMargin.constant = 30
            menuHeightConstraint.constant = 100
        }else if UIDevice.currentDevice().modelName.containsString("iPhone 4") || UIScreen.mainScreen().bounds.size.height == 480.0{
            lbTitle.font = lbTitle.font.fontWithSize(25)
            titleFont = lbTitlePref.font.fontWithSize(12)
            lbTitlePref.font = titleFont;
            lbTitleScholarship.font = titleFont;
            lbTitleReview.font = titleFont;
            menuIconPading.constant = 10
            menuIconWidth.constant = 50
            middleTopMargin.constant = 20
            middleBottomMargin.constant = 20
            menuHeightConstraint.constant = 80
            registerMarginBottom.constant = 0

        }else if UIScreen.mainScreen().bounds.size.height == 667.0{
            lbTitle.font = lbTitle.font.fontWithSize(28)
            titleFont = lbTitlePref.font.fontWithSize(15)
            lbTitlePref.font = titleFont;
            lbTitleScholarship.font = titleFont;
            lbTitleReview.font = titleFont;
            middleTopMargin.constant = 30
            middleBottomMargin.constant = 30
            menuHeightConstraint.constant = 120
        }else if UIScreen.mainScreen().bounds.size.height >= 736.0{
            lbTitle.font = lbTitle.font.fontWithSize(30)
            titleFont = lbTitlePref.font.fontWithSize(17)
            lbTitlePref.font = titleFont;
            lbTitleScholarship.font = titleFont;
            lbTitleReview.font = titleFont;
            middleTopMargin.constant = 50
            middleBottomMargin.constant = 50
            menuHeightConstraint.constant = 130

        }
        print("screenHeight\(UIScreen.mainScreen().bounds.size.height)")

    }
    func layoutForLoginSate(){
        if AppRuntime.sharedInstance.isLogin(){
            btnLogin.setTitle("Logout", forState: .Normal)
            imvLogin.setImage(UIImage(named: "ic_logout"), forState: .Normal)
            registerView.hidden = true
            
        }else{
            btnLogin.setTitle("Login", forState: .Normal)
            imvLogin.setImage(UIImage(named: "ic_login"), forState: .Normal)
            registerView.hidden = false
        }
    }
    @IBAction func pressedRegister(sender: AnyObject) {
        performSegueWithIdentifier(segueRegister, sender: nil)
    }
    
    @IBAction func pressedSubmit(sender: AnyObject) {
        print("show camera review")
        if AppRuntime.sharedInstance.isLogin(){
            if let cameraGuideScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CameraGuideScreen") as? CameraGuideScreen{
                self.navigationController?.pushViewController(cameraGuideScreen, animated: true)
            }
        }else{
            toView = DestinationView.SubmitReview
            performSegueWithIdentifier(segueLogin, sender: nil)
        }

    }
    
    @IBAction func pressedScholarship(sender: AnyObject) {
        if AppRuntime.sharedInstance.isLogin(){
            performSegueWithIdentifier(segueScholaship, sender: nil)

        }else{
            toView = DestinationView.Schalarship

            performSegueWithIdentifier(segueLogin, sender: nil)
        }
    }
    @IBAction func pressedSAT(sender: AnyObject) {
        performSegueWithIdentifier(seguePreSat, sender: nil)
    }
    
    @IBAction func pressedSignout(sender: AnyObject) {
        if AppRuntime.sharedInstance.isLogin(){
            AppRuntime.sharedInstance.removeToken()
            layoutForLoginSate()
        }else{
            toView = DestinationView.Home
            performSegueWithIdentifier(segueLogin, sender: nil)
        }

    }
    override func pressedBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}

extension HomeViewController{
    func changeToWellcomeScreen(){
        if let wellcomeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("wellcomeViewController") as? WellcomeViewController{
//            let nav = UINavigationController(rootViewController: wellcomeViewController)
//            nav.navigationBarHidden = true
            
            self.navigationController?.pushViewController(wellcomeViewController, animated: true)
            
        }

    }
}