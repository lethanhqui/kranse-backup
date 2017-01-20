//
//  LoginViewController.swift
//  Kranse
//
//  Created by macbook on 9/19/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
enum InputErrorType: Int {
    case Empty = 0,
    EmptyOrderNumber,
    EmptyLastName,
    DoNotAgree,
    Valid
    
}
enum IndexTextField: Int{
    case Normal = 0,
    Order,
    Name,
    None
}
enum DestinationView:Int {
    case Home = 0,Schalarship,SubmitReview
}
class LoginViewController: BaseViewController {
    @IBOutlet weak var btnLoginBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfOrderNumber: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnCheckBox: UIButton!
    
    @IBOutlet weak var textFieldMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnTermsConditionls: UIButton!
    
    @IBOutlet weak var textFieldMargin: NSLayoutConstraint!
    var indexTextField : IndexTextField?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var containView: UIView!
    
    var toView:DestinationView = DestinationView.Home
    var goto:Bool = true
    var marginBottom:CGFloat = 160
    override func viewDidLoad() {
        super.viewDidLoad()
        registerObserver()
        showBackButton("",black: false)
        //register
        let lineBottom = CALayer()
        lineBottom.frame = CGRectMake(0, CGRectGetHeight(btnTermsConditionls.frame) - 6, CGRectGetWidth(btnTermsConditionls.frame), 1)
        lineBottom.backgroundColor = UIColor.whiteColor().CGColor
        btnTermsConditionls.layer.addSublayer(lineBottom)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(LoginViewController.gestureHandle(_:)))
        containView.addGestureRecognizer(gesture)
        tfLastName.inputAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tfOrderNumber.inputAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigatorBarTranslucent(true);
        let screenH = UIScreen.mainScreen().bounds.size.height
        self.scrollView.scrollEnabled = false
        if         UIDevice.currentDevice().modelName.containsString("iPhone 5"){
            textFieldMarginConstraint.constant = 30
            UIView.animateWithDuration(0.1) {
                self.view.updateConstraintsIfNeeded()
            }
            
        } else if (UIDevice.currentDevice().modelName.containsString("iPhone 4") || screenH == 480.0){
            self.scrollView.scrollEnabled = true

        } else if (UIDevice.currentDevice().model.containsString("iPhone 7")){
            marginBottom = 250
            btnLoginBottomConstraint.constant = marginBottom
            UIView.animateWithDuration(0.1) {
                self.view.updateConstraintsIfNeeded()
            }
        }else if (UIDevice.currentDevice().model.containsString("iPhone 6")){
            marginBottom = 250
            btnLoginBottomConstraint.constant = marginBottom
            UIView.animateWithDuration(0.1) {
                self.view.updateConstraintsIfNeeded()
            }
        }else if (screenH >= 667.0){
            marginBottom = 250
            btnLoginBottomConstraint.constant = marginBottom
            UIView.animateWithDuration(0.1) {
                self.view.updateConstraintsIfNeeded()
            }
        }
        print("\(UIScreen.mainScreen().bounds.size.height)")
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        textFieldMargin.constant = 45
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "termandconditionalSegue" {
            guard let webview = segue.destinationViewController as? KranseWebviewController else {return}
            webview.addressType = AddressType.TermAndConditional.rawValue
            
        }
    }
    func gestureHandle(notif:UIGestureRecognizer){
        if notif.state == UIGestureRecognizerState.Ended {
            self.view.endEditing(true)
        }
    }
    //MARK
    func registerObserver(){
        self.tfLastName.delegate = self;
        self.tfOrderNumber.delegate = self
    //keyboard Observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification , object: nil)
    }
    func keyboardWillShow(notification: NSNotification){
//        btnLoginBottomConstraint.constant = 250
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        if marginBottom < keyboardHeight + 65{
        btnLoginBottomConstraint.constant = keyboardHeight + 65
            if UIScreen.mainScreen().bounds.size.height == 480.0{
                if indexTextField == IndexTextField.Order {
                     btnLoginBottomConstraint.constant = keyboardHeight
                }
            }
            UIView.animateWithDuration(0.2) {
                self.view.updateConstraintsIfNeeded()
            }
        }
    }
    func keyboardWillHide(notif: NSNotification){
        btnLoginBottomConstraint.constant = marginBottom;
        UIView.animateWithDuration(0.2) {
            self.view.updateConstraintsIfNeeded()
        }
    }
    @available(iOS 9.0, *)
    func hideKeyboardToolBar(textField : UITextField){
        let item : UITextInputAssistantItem = textField.inputAssistantItem
        item.leadingBarButtonGroups = []
        item.trailingBarButtonGroups = []
    
    }
    func validateInputForm() ->InputErrorType.RawValue{
        if tfLastName.text?.characters.count == 0  {
            return InputErrorType.EmptyLastName.rawValue
        }
        if tfOrderNumber.text?.characters.count == 0{
            return InputErrorType.EmptyOrderNumber.rawValue

        }
        if btnCheckBox.selected == false {
            return InputErrorType.DoNotAgree.rawValue
        }
        return InputErrorType.Valid.rawValue
    }
    
    @IBAction func pressedLogin(sender: AnyObject) {
      
        doLogin()
    }
    @IBAction func pressedTermAndConditional(sender: AnyObject) {
    }
    @IBAction func pressedAgree(sender: AnyObject) {
        btnCheckBox.selected = !btnCheckBox.selected
    }
    func doLogin(){
//        changeToHomeScreen()
        if !isConnectedToNetwork() {
          showAlertWithMessage(AppErrorCode.NoInternetConnection.rawValue)
            return
        }
        let valid = validateInputForm()
        self.view.endEditing(true)
        switch valid {
        case InputErrorType.EmptyLastName.rawValue:
            showAlertWithMessage("Last name can not be empty")
            break
        case InputErrorType.EmptyOrderNumber.rawValue:
            showAlertWithMessage("Order number can not be empty")
            break
        case InputErrorType.DoNotAgree.rawValue:
            showAlertWithMessage("Please agree with the Terms and Conditionals")
            
            break
        case InputErrorType.Valid.rawValue:
            
            break
        default:
            
            break
        }
        if valid != InputErrorType.Valid.rawValue{
            return
        }
        showLoadingView()
        let orderNumber =  tfOrderNumber.text
        let lastName = tfLastName.text
        BaseApiService.getUserInfo(["order_number":orderNumber!,"last_name":lastName!]) { (result) in
            self.hideLoadingView()
            if result.allKeys.count > 0{
                guard let status  = result["status"] as? String else {return}
                if status == APIStatus.success.rawValue{
                    guard let data = result["data"] as? [String:String] else {return}
                    let token = data["token"]
                    AppRuntime.sharedInstance.userToken = token
                    AppRuntime.sharedInstance.saveToken(token!)
                    if self.goto == true{
                        self.gotoView()
                    }else{
                    self.changeToHomeScreen()
                    }
                }else if status == APIStatus.error.rawValue{
                    guard let message = result["message"] as? String else {return}
                    self.showAlertWithMessage(message)
                }
            }else{
                self.showAlertWithMessage(AppErrorCode.Unknown.rawValue)

            }
            print("login \(result)")
        }
    }
    func gotoView(){
        switch toView {
        case DestinationView.Home:
            changeToHomeScreen()
            break
        case DestinationView.Schalarship:
            if let cameraGuideScreen = UIStoryboard(name: "Guide", bundle: nil).instantiateViewControllerWithIdentifier("scholarshipIntriViewController") as? ScholarshipIntriViewController{
                self.navigationController?.pushViewController(cameraGuideScreen, animated: true)
            }
            break
        case DestinationView.SubmitReview:
            if let cameraGuideScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CameraGuideScreen") as? CameraGuideScreen{
                self.navigationController?.pushViewController(cameraGuideScreen, animated: true)
            }
            break
       
        }
//        self.navigationController?.popViewControllerAnimated(false)

    }
    func changeToHomeScreen(){
        var hasHome = false
        if let viewcontrolelrs = self.navigationController?.viewControllers{
            for viewcontroller in viewcontrolelrs{
//            let homecontroller  = viewcontrolelrs[0]
            if viewcontroller.isKindOfClass(HomeViewController){
                hasHome = true
                self.navigationController?.popToViewController(viewcontroller, animated: true)
                
            }
            }
        }
        if !hasHome{
//            let introVC = self.storyboard?.instantiateViewControllerWithIdentifier("homeViewController") as? HomeViewController
//            let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
//            
//            let nav = UINavigationController(rootViewController: introVC!)
//            delegate?.window?.rootViewController = nav
//            delegate?.window?.makeKeyWindow()
//            delegate?.window?.makeKeyAndVisible()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
//        self.navigationController?.pushViewController(introVC!, animated: true)
        
    }
}
extension LoginViewController : UITextFieldDelegate{
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if #available(iOS 9.0, *) {
            hideKeyboardToolBar(textField)
        } else {
            // Fallback on earlier versions
        }
        if textField == tfOrderNumber {
            indexTextField = IndexTextField.Order
        }else if textField == tfLastName{
            indexTextField = IndexTextField.Name
        
        }
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == tfOrderNumber {
            tfLastName.becomeFirstResponder()
        }else if(textField == tfLastName){
            tfLastName.resignFirstResponder()
            doLogin()
        }
        indexTextField = IndexTextField.None

        return true
    }
}