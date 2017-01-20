//
//  ScholarshipPreviewPicViewController.swift
//  Kranse
//
//  Created by macbook on 9/20/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
class ScholarshipPreviewPicViewController:BaseViewController, DiscardDialogDelegate{
    var previewImage: UIImage?
    
    @IBOutlet weak var btnDiscard: UIButton!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var imgPreview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard self.navigationController != nil else{return}
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.imgPreview.image = previewImage

    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "scholarshipDiscardSegue" {
            guard let discardDialog = segue.destinationViewController as? ScholarDiscardDialog else {return}
            discardDialog.delegate = self
        }else if segue.identifier == "scholarshipSubmitSegue"{
            guard let discardDialog = segue.destinationViewController as? ScholarshiSubmitDialog else {return}
            discardDialog.delegate = self
        }
    }
    @IBAction func pressedDiscard(sender: AnyObject) {
        showDiscardDialog()
        btnDiscard.hidden = true
        btnSubmit.hidden = true
        
    }
    @IBAction func pressedSubmit(sender: AnyObject) {
        submitScholarship()
        btnDiscard.hidden = true
        btnSubmit.hidden = true

    }
    func showDiscardDialog(){
        self.performSegueWithIdentifier("scholarshipDiscardSegue", sender: self)
    }
    
    //MARK - DiscardDelegate
    func didSelectOK() {
        submitScholarship()
    }
    
    func didSelectCancel() {
        backToController(HomeViewController)
    }
    func submitScholarship(){
        if !isConnectedToNetwork() {
            showAlertWithMessage(AppErrorCode.NoInternetConnection.rawValue)
            return
        }
        showLoadingView()
        BaseApiService.uploadData(self.previewImage!) { (result) in
            self.hideLoadingView()
            if result.allKeys.count > 0{
            if let status = result["status"] as? String {
                if status == APIStatus.success.rawValue{
                    self.showSuccessDialog()
                }else if(status == APIStatus.error.rawValue){
                    if let message =  result["message"] as? String{
                        self.showAlertWithMessage(message)
                    }else{
                        self.showAlertWithMessage(AppErrorCode.Unknown.rawValue)
                    }
                }
            }else{
                self.showAlertWithMessage(AppErrorCode.Unknown.rawValue)
                
            }
            }else{
                self.showAlertWithMessage(AppErrorCode.Unknown.rawValue)

            }
        }
    }
 
    override func hideLoadingView(){
        
        guard (activityIndicator != nil) else {return}
        activityIndicator?.stopAnimating()
        
    }
    func showSuccessDialog(){
        self.performSegueWithIdentifier("scholarshipSubmitSegue", sender: self)
    }
    
}