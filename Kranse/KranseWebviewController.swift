//
//  KranseWebviewController.swift
//  Kranse
//
//  Created by macbook on 9/20/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
enum AddressType: Int{
    case Register =  0,
    TermAndConditional,
    PrepForTheSat,
    unknow
}
class KranseWebviewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webview: UIWebView!
    var addressType : AddressType.RawValue?
    var isfillData : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.delegate = self
        setNavigatorBarTranslucent(true)

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard firstTime else {return}
        firstTime = false
        showBackButton("Back",black: true)
        guard let type = addressType else {return}
        var path = "https://www.kranse.com/"
        switch type {
        case AddressType.Register.rawValue:
            path = "https://www.kranse.com/"
            break
        case AddressType.TermAndConditional.rawValue:
            path = "https://www.kranse.com/"
            break
        case AddressType.PrepForTheSat.rawValue:
            path = "http://class.kranse.com/"
            break

        default:
            path = "https://www.kranse.com/"
            break
        }
       
        let url = NSURL (string: path);
        let requestObj = NSURLRequest(URL: url!);
        webview.loadRequest(requestObj);
        showLoadingView()
    }
    func findAndFillData(){
        //create js strings
//        NSString *loadUsernameJS = [NSString stringWithFormat:@"var inputFields = document.querySelectorAll(\"input[type='text']\"); \
        let password = "123456"
        let username = "hai@gmail.com"
        let loadUsernameJS = "document.getElementById('user_email').value=\(username);"
        
        let loadPasswordJS = "document.getElementById('user_password').value=\(password);"
        
        let loadRememberJS = "document.getElementById('user_remember_me').checked=true;"
    
        webview.stringByEvaluatingJavaScriptFromString(loadUsernameJS)
        webview.stringByEvaluatingJavaScriptFromString(loadPasswordJS)
        webview.stringByEvaluatingJavaScriptFromString(loadRememberJS)
    
    }
    func clickOnSubmitButton(){
       let performSubmitJS = "document.getElementById('btn-signin').click()"
 
        webview.stringByEvaluatingJavaScriptFromString(performSubmitJS)
    }

}
extension KranseWebviewController{
    func webViewDidStartLoad(webView: UIWebView) {
        print("didstart");
        //        showLoadingView()
    }
    func webViewDidFinishLoad(webView: UIWebView){
        print("didFinished")
                hideLoadingView()
        if addressType == AddressType.PrepForTheSat.rawValue {
            if isfillData == false {
                isfillData = true
                findAndFillData()
//                clickOnSubmitButton()
            }
            
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("didError")
                hideLoadingView()
    }
}