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
                          "Username":Username
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
                                print(logoutMessage["ResponseMsg"],logoutMessage["ResponseCode"])
                                print("SessionUUID",SessionUUID)
                                self.dismiss(animated: true, completion: nil)
                            }else if logoutMessage["ResponseCode"] == "400"{
                                //操作失败/参数非法
                                self.WarningAlert(alertContent: logoutMessage["ResponseMsg"].stringValue)
                                print(logoutMessage["ResponseMsg"],logoutMessage["ResponseCode"])
                            }else{
                                //其他错误
                                self.WarningAlert(alertContent: logoutMessage["ResponseMsg"].stringValue)
                                print("其他错误")
                                print(logoutMessage["ResponseCode"])
                                print(logoutMessage["ResponseMsg"])
                            }
                        case .failure(let error):
                            print(error)
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
                            let setPasswordMessage = JSON(value)
                            print(setPasswordMessage)
                            if setPasswordMessage["ResponseCode"] == "200" {
                                //成功
                                print(setPasswordMessage["ResponseMsg"],setPasswordMessage["ResponseCode"])
                                self.dismiss(animated: true, completion: nil)
                            }else if setPasswordMessage["ResponseCode"] == "400"{
                                //操作失败/参数非法
                                self.view.showError(setPasswordMessage["ResponseMsg"].stringValue)
                                print(setPasswordMessage["ResponseMsg"],setPasswordMessage["ResponseCode"])
                            }else{
                                //其他错误
                                self.view.showError(setPasswordMessage["ResponseMsg"].stringValue)
                                print("其他错误")
                                print(setPasswordMessage["ResponseCode"])
                                print(setPasswordMessage["ResponseMsg"])
                            }
                        case .failure(let error):
                            print(error)
                            self.view.showError(error.localizedDescription)
                        }
                   })
        
    }
}
