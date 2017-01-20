//
//  AppRunetime.swift
//  Kranse
//
//  Created by macbook on 9/21/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
class AppRuntime: NSObject {
    
    static let sharedInstance = AppRuntime()
    
    var userToken: String?
//    var userProfile: UserProfile? = UserProfile.loadUserProfile(){
//        didSet{
//            if let userProfile = userProfile {
//                userProfile.cachedUserProfile()
//            }
//        }
//    }
//    var customerMemberClassInfo: CustomerMemberClassInfo?
//    var currentPaymentStatus: PaymentCurrentStatusInfo?
//    
//    func loadUserCachedInfo() {
//        self.userToken = UserToken.loadUserToken()
//        //        self.userProfile = UserProfile.loadUserProfile()
//        self.customerMemberClassInfo = CustomerMemberClassInfo.loadMemberClassInfo()
//    }
//    
//    var wasLogin: Bool {
//        guard let _ = self.userToken else { return false }
//        //        guard let _ = self.userProfile else { return false }
//        guard let _ = self.customerMemberClassInfo else { return false }
//        return true
//    }
//    
//    class func logOut() {
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        userDefaults.removeObjectForKey(UserDefaultKeyToken)
//        UserProfile.deleteProfile()
//        userDefaults.removeObjectForKey(UserDefaultsUserMemberClassInfoKey)
//        userDefaults.synchronize()
//    }
    func removeToken(){
        AppRuntime.sharedInstance.userToken = nil
        let pref = NSUserDefaults.standardUserDefaults()
        pref.removeObjectForKey("token")
        pref.synchronize()
    }
    func saveToken(token:String?){
        let pref = NSUserDefaults.standardUserDefaults()
        pref.setObject(token, forKey: "token")
    }
    func isLogin() ->Bool{
        let pref = NSUserDefaults.standardUserDefaults()
        if let token = pref.objectForKey("token") as? String{
            userToken = token
            return true
        }else{
            return false
        }
    }
    func isFirstTime() ->Bool{
        let pref = NSUserDefaults.standardUserDefaults()
        let fisttime = pref.boolForKey("fristtime")
        return fisttime
        
    }
    func setFristTime(){
        let pref = NSUserDefaults.standardUserDefaults()
        pref.setBool(true, forKey: "fristtime")
    }
    
}

enum AppErrorCode: String {
    case Unknown = "Unknown"
    case NoInternetConnection = "No internet connection"
}