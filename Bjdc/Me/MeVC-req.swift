//
//  MeVC-req.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/2.
//

import Foundation
import Alamofire
import SwiftyJSON
extension Setting{
    
    func doLogout(){
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID,
        ]
        AF.request("\(networkInterface)doLogout.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    switch response.result {
                        case .success(let value):
                            let logoutMessage = JSON(value)
                            print(logoutMessage)
                            if logoutMessage["ResponseCode"] == "205" {
                                //成功注销

                                projectTitles = [String]()
                                RedirectApp(VC: self)
                            }else if logoutMessage["ResponseCode"] == "400"{
                                //操作失败/参数非法
                                self.WarningAlert(alertContent: logoutMessage["ResponseMsg"].stringValue)
                            }else{
                                //其他错误
                                self.WarningAlert(alertContent: logoutMessage["ResponseMsg"].stringValue)
                                if logoutMessage["ResponseCode"] == "400110"{
                                    RedirectApp(VC: self)
                                }
                            }
                        case .failure(let error):
                            print(error)
                            self.WarningAlert( alertContent: "出现未知错误，请重试！")
                        }
                   })
                    
    }
}
extension ChangePasswordVC{
    

    
    func setPassword(){
        
        let key = SessionUUIDmd5?.lowercased()
        let iv = key![24...]
        let text1 = self.originalPassword
        let text2 = self.newPassword
        var encryptOriginalPassword:String?
        var encryptNewPassword:String?
        encryptOriginalPassword = text1.tripleDESEncryptOrDecrypt(op: CCOperation(kCCEncrypt), key: key!, iv: iv)
        print("加密内容："+(encryptOriginalPassword ?? "加密失败"))
        encryptNewPassword = text2.tripleDESEncryptOrDecrypt(op: CCOperation(kCCEncrypt), key: key!, iv: iv)
        print("加密内容："+(encryptNewPassword ?? "加密失败"))
        
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID,
                          "OldPassword":encryptOriginalPassword,
                          "NewPassword":encryptNewPassword,
        ]
        
        AF.request("\(networkInterface)setPassword.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    switch response.result {
                        case .success(let value):
                            //更新Session有效期
                            UpdateSessionAccessTime()
                            let setPasswordMessage = JSON(value)
                            print(setPasswordMessage)
                            if setPasswordMessage["ResponseCode"] == "200" {
                                //成功
                                self.view.showSuccess("重置密码成功！")
                                do{
                                    try realm.write {
                                        realm.objects(UserAccountReaml.self).first!.password = ""
                                    }
                                }catch{
                                    print(error)
                                }
                                self.dismiss(animated: true, completion: nil)
                            }else if setPasswordMessage["ResponseCode"] == "400"{
                                //操作失败/参数非法
                                self.view.showError(setPasswordMessage["ResponseMsg"].stringValue)
                            }else{
                                //其他错误
                                self.view.showError(setPasswordMessage["ResponseMsg"].stringValue)
                                if setPasswordMessage["ResponseCode"] == "400110"{
                                    RedirectApp(VC: self)
                                }
                            }
                        case .failure(let error):
                            print(error)
                            self.view.showError(error.localizedDescription)
                        }
                   })
        
    }
}
extension PersonalInfo{
    func getUserInformation(sema: DispatchSemaphore){
             
        let stringArray : [String] = [Username!]
//        let parameters = [
//            "AccessToken":AccessToken!,
//            "SessionUUID":SessionUUID,
//
//        ]
//        print(parameters)
        let tokenInfo = AccessToken!
        let sessionInfo = SessionUUID
        struct parameterInof: Encodable {
            let AccessToken: String
            let SessionUUID: String
            let UserName: [String]
        }

        let ParameterInof = parameterInof(AccessToken: tokenInfo, SessionUUID: sessionInfo, UserName: stringArray)

        AF.request("\(networkInterface)getUserInformation.php",
                   method: HTTPMethod.post,
                   parameters: ParameterInof,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { [self] response in
                    switch response.result {
                        case .success(let value):
                            let UserInformation = JSON(value)
                            InfoMessage = UserInformation["ResponseMsg"].stringValue
                            InfoCode = UserInformation["ResponseCode"].stringValue
                            if UserInformation["ResponseCode"] == "200" {
                                //成功
                                print(UserInformation["ResponseMsg"],UserInformation["ResponseCode"])
                                print(UserInformation["UserList"])
                                self.UserList = UserInformation["UserList"]
                                sema.signal()
                            }else if UserInformation["ResponseCode"] == "400"{
                                //操作失败/参数非法
                                sema.signal()
                            }else{
                                //其他错误
                                sema.signal()
                            }
                        case .failure(let error):
                            InfoMessage = "网络请求错误！"
                            print(error)
                        }
                   })
                    
    }
}
