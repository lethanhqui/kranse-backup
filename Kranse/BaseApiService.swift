//
//  BaseApiService.swift
//  Kranse
//
//  Created by macbook on 9/21/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
import Alamofire
public enum APIStatus : String {
    case success = "success", error = "error", fail = "fail"
    
    static let allValues = [success, error]
}

class BaseApiService : NSObject{
    static let X_API_ID:String = "kranse";
    static let X_API_KEY:String = "1qazxcde32ws";
    static let API_BASE_URL = "http://webhook.kranse.com/"
    static let API_USER_DETAIL = "api/login"
    static let API_LOGIN = "api/login"
    static let API_SCHOLARSHIP_SUBMIT = "api/scholarship/submit"
    static let API_QUESTIONS_LIST = "api/question/list"
    static let API_CAMERA_SUBMIT = "api/camera/submit"
    static let API_CAMERA_CHECK = "api/camera/check"
    
    static func header()->[String:String]{
        let headers = [
            "X-DEVICE-ID":"123456",
            "X-OS-TYPE":"IOS",
            "X-OS-VERSION":DeviceService.getIOSVersion(),
            "X-APP-VERSION":DeviceService.getAppVersion(),
            "X-API-ID":X_API_ID,
            "X-API-KEY":X_API_KEY
        ]
        return headers;
    }
    static func getUserInfo(params:[String:String], completion: (result: NSDictionary) -> Void){
        
        let requestURL = "\(API_BASE_URL)\(API_LOGIN)"
        print("\(requestURL)")
        let headers = BaseApiService.header()
        print("header\(headers)")
        Alamofire.request(.POST, requestURL, parameters: params, encoding: ParameterEncoding.JSON, headers: headers).responseJSON { response in
            
            switch response.result {
            case .Success(let data):
                if let json = data as? NSDictionary{
                    completion(result: json)
                }
            case .Failure(let error):
                completion(result: [:])
                print("Request failed with error: \(error)")
            }
        }
    }
    static func uploadData(image : UIImage, completion: (result: NSDictionary) ->Void){
        
        let URL = "\(API_BASE_URL)\(API_SCHOLARSHIP_SUBMIT)"
        let headers = BaseApiService.header()
        
        Alamofire.upload(.POST, URL, headers: headers, multipartFormData: { multipartFormData in
            
            
            if let imageData = UIImageJPEGRepresentation(image,1) {
                multipartFormData.appendBodyPart(data: imageData, name: "file", fileName: "file.jpeg", mimeType: "image/png")
            }
            
            
            if let token = AppRuntime.sharedInstance.userToken {
                print("token\(token)")
                multipartFormData.appendBodyPart(data: token.dataUsingEncoding(NSUTF8StringEncoding)!, name: "token")
            }
            
            }, encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold,
               encodingCompletion:  { encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        print("suceess ::: \(response)")
                        if let result = response.result.value as? NSDictionary{
                            completion(result: result)
                        }else{
                            completion(result: [:])
                            
                        }
                        
                    }
                    //                    upload.responseString(completionHandler: { response in
                    //                        print("success : \(response)")
                //                    })
                case .Failure(let encodingError):
                    print("error ::: \(encodingError)")
                    completion(result: [:])
                    
                }
                
        })
    }
    
    static func getquestionLists(params:[String:String], completion: (result: NSDictionary?) -> Void){
        
        let requestURL = "\(API_BASE_URL)\(API_QUESTIONS_LIST)"
        print("\(requestURL)")
        let headers = BaseApiService.header()
        print("header\(headers)")
        Alamofire.request(.POST, requestURL, parameters: params, encoding: ParameterEncoding.JSON, headers: headers).responseJSON { response in
            
            completion(result: (response.result.value as? NSDictionary )!)
            
        }
    }
    
    static func uploadVideoReview(url : NSURL,questionID : String,isFinal : Bool, completion: (result: NSDictionary) ->Void){
        
        let URL = "\(API_BASE_URL)\(API_CAMERA_SUBMIT)"
        let headers = BaseApiService.header()
        
        Alamofire.upload(.POST, URL, headers: headers, multipartFormData: { multipartFormData in
            
            if let data = NSData(contentsOfURL: url)  {
                multipartFormData.appendBodyPart(data: data, name: "file", fileName: "file.mov", mimeType: "video/mov")
            }
            
            if let token = AppRuntime.sharedInstance.userToken {
                print("token\(token)")
                multipartFormData.appendBodyPart(data: token.dataUsingEncoding(NSUTF8StringEncoding)!, name: "token")
            }
            multipartFormData.appendBodyPart(data: questionID.dataUsingEncoding(NSUTF8StringEncoding)!, name: "question_id")
            
            let final = (isFinal ? "true" : "false").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            multipartFormData.appendBodyPart(data: final, name: "final")
            
            print("question id \(questionID) isfinal : \(isFinal))")
            
            }, encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold,
               encodingCompletion:  { encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        print("suceess ::: \(response)")
                        if let result = response.result.value as? NSDictionary{
                            completion(result: result)
                        }else{
                            completion(result: [:])
                            
                        }
                    }
                case .Failure(let encodingError):
                    print("error ::: \(encodingError)")
                    completion(result: [:])
                    
                }
                
        })
    }
    
    // type: 1|2 (1 là scholarship, 2 là camera review)
    static func reviewCheck(isCameraReview:Bool, completion: (isOK:Bool, checkOk:Bool, message:String?) -> Void){
        
        let requestURL = "\(API_BASE_URL)\(API_CAMERA_CHECK)"
        print("\(requestURL)")
        let headers = BaseApiService.header()
        print("header\(headers)")
        let params = ["token":AppRuntime.sharedInstance.userToken!, "type": "\(isCameraReview ? 2 : 1)"]
        Alamofire.request(.POST, requestURL, parameters: params, encoding: ParameterEncoding.JSON, headers: headers).responseJSON { response in
            if let result =  response.result.value as? NSDictionary{
                print(result)
                guard let status  = result["status"] as? String else {return}
                if status == APIStatus.success.rawValue{
                    if let resultdic = result["data"] as? NSDictionary{
                        if let sta = resultdic["status"] as? Bool{
                            completion(isOK: true, checkOk: sta, message: nil)
                            return
                        }
                    }
                    completion(isOK: false, checkOk: false, message: AppErrorCode.Unknown.rawValue)
                }else if status == APIStatus.error.rawValue{
                    if let message = result["message"] as? String {
                        completion(isOK: false, checkOk: false, message: message)
                    }
                    
                }
            }
            
        }
    }
}