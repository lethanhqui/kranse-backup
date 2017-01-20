//
//  FTPServices.swift
//  Kranse
//
//  Created by ITV MAC 01 on 9/21/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
import Alamofire

class FTPServices: NSObject {
    var totalQuestion = 0
    var questionCount = 0
    var submitVideoFinish:((url:NSURL, questionID : Int, isOK:Bool,message:String?)->())?
    
    func uploadVideoReview(url : NSURL, questionID : Int,isFinal : Bool ,handleComplete:((isOK:Bool, urlReturn : String?,message:String?)->())){
        BaseApiService.uploadVideoReview(url, questionID: "\(questionID)", isFinal: isFinal) { (result) in
            if let status = result["status"] as? String {
                if status == APIStatus.success.rawValue{
                    self.questionCount = self.questionCount - 1
                    handleComplete(isOK: true, urlReturn: url.absoluteString, message: nil)
                }else if(status == APIStatus.fail.rawValue){
                    if let message =  result["message"] as? String{
                        handleComplete(isOK: false, urlReturn: nil, message: message)
                    }else{
                       handleComplete(isOK: false, urlReturn: nil, message: AppErrorCode.Unknown.rawValue)
                    }
                }
            }else{
                handleComplete(isOK: false, urlReturn: nil, message: AppErrorCode.Unknown.rawValue)
                
            }
        }
    }
}