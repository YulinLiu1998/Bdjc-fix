//
//  LoginVC-accessToken.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/31.
//

import Foundation
import Alamofire
import SwiftyJSON
extension LoginVC{
    func accessToken(){

        struct TokenMessage:Codable{
            let ResponseCode:String
            let ResponseMsg:String
            let AccessToken:String
            let ExpireTimestamp:Int
        }
        //
        let parameters = ["GrantType":"BDJC",
                          "AppID":"UzHky82L6hOKCAsI5MBQYImw",
                          "AppSecret":"HCarvgfeeCQlFoWfo8lylh7aF61wNNBjv8FriEw"
        ]
      //MARK: -  Decodable请求方式
//        AF.request("http://172.18.7.86/bdjc/API/getAccessToken.php",
//                   method: HTTPMethod.post,
//                   parameters: parameters,
//                   encoder: JSONParameterEncoder.default).responseDecodable(of: TokenMessage.self) { response in
//
//                    print(response.value)
//                    if let tokenMessage = response.value{
//                        print(tokenMessage.ResponseCode)
//                        print(tokenMessage.ResponseMsg)
//                        print(tokenMessage.AccessToken)
//                        print(tokenMessage.ExpireTimestamp)
//                        AccessToken = tokenMessage.AccessToken
//                    }else{
//
//                    }
//                   }
        AF.request("http://172.18.7.86/dist/API/getAccessToken.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    switch response.result {
                        case .success(let value):
                            let tokenMessage = JSON(value)
                            if tokenMessage["ResponseCode"] == "200" {
                                AccessToken = tokenMessage["AccessToken"].stringValue
                                ExpireTimestamp = tokenMessage["ExpireTimestamp"].int
                            }else{
                                print(tokenMessage["ResponseCode"])
                                print(tokenMessage["ResponseMsg"])
                            }
                            
                            
                        case .failure(let error):
                            print(error)
                        }
                   })
                    
                  
    }
    func doSession(){
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID,
        ]
        AF.request("http://172.18.7.86/dist/API/doSession.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    switch response.result {
                        case .success(let value):
                            let doSessionMessage = JSON(value)
                            if doSessionMessage["ResponseCode"] == "202" {
                                //未登录时
                                SessionUUID = doSessionMessage["SessionUUID"].stringValue
                                SessionUUIDmd5 = SessionUUID.md5
                            }else if doSessionMessage["ResponseCode"] == "201"{
                                //已登录时
                                print("\(doSessionMessage["UserName"])")
                            }
                        case .failure(let error):
                            print(error)
                        }
                   })
                    
    }
    func doLogin(sema: DispatchSemaphore){
         
        let key = SessionUUIDmd5?.lowercased()
        let iv = key![24...]
        let text = self.passwordStr
        var encryptText:String?
        //var decrptText:String?
        encryptText = text.tripleDESEncryptOrDecrypt(op: CCOperation(kCCEncrypt), key: key!, iv: iv)
        //decrptText = encryptText?.tripleDESEncryptOrDecrypt(op: CCOptions(kCCDecrypt), key: key!, iv: iv)
        
        Username = self.accountStr
        
        
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID,
                          "Username":self.accountStr,
                          "Password":encryptText
        ]
        
        AF.request("http://172.18.7.86/dist/API/doLogin.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    switch response.result {
                        case .success(let value):
                            let loginMessage = JSON(value)
                            print("loginMessage",loginMessage)
                            if loginMessage["ResponseCode"] == "200" {
                                //成功登录
                                sema.signal()
                                //self.performSegue(withIdentifier: "LoginToTabBar", sender: nil)
                            }else if loginMessage["ResponseCode"] == "400"{
                                //若输入的密码格式错误，则返回400错误码，错误信息为“请输入正确的账号密码
                                sema.signal()
                                print("400")
                                print(loginMessage["ResponseMsg"],loginMessage["ResponseCode"])
                            }else{
                                sema.signal()
                                //其他错误
                                print("其他错误loginMessage")
                                print(loginMessage["ResponseCode"])
                                print(loginMessage["ResponseMsg"])
                            }
                        case .failure(let error):
                            print(error)
                            sema.signal()
                        }
                   })
       
                    
    }
    func getProjects(sema: DispatchSemaphore){
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID
        ]
     
        //showLoadHUD()
        AF.request("http://172.18.7.86/dist/API/getProjects.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    //self.hideLoadHUD()
                    switch response.result {
                        case .success(let value):
                            let getProjectsMessage = JSON(value)
                            if getProjectsMessage["ResponseCode"] == "200" {
                                //获取项目列表
                                ProjectList = getProjectsMessage["ProjectList"]
                                //获取项目总数
                                ProjectNum = ProjectList?.count
                                for i in 0 ..< ProjectList!.count  {
                                    //MARK: -获取项目名字
                                    let name = ProjectList![i]["ProjectName"].stringValue
                                    projectTitles.append(name)
                                    //MARK: -获取工程站点状态
                                    let projectStationStatus:JSON = ProjectList![i]["ProjectStationStatus"]
                                    print("projectStationStatus",projectStationStatus)
                                    //警告
                                    let warning = projectStationStatus["Warning"].stringValue
                                    pssWarning.append(warning)
                                    //故障
                                    let Error = projectStationStatus["Error"].stringValue
                                    pssError.append(Error)
                                    //离线
                                    let Offline = projectStationStatus["Offline"].stringValue
                                    pssOffline.append(Offline)
                                    //在线
                                    let Online = projectStationStatus["Online"].stringValue
                                    pssOnline.append(Online)
                                    //总数
                                    let Total = projectStationStatus["Total"].stringValue
                                    pssTotal.append(Total)
                                    //MARK: -获取项目中站点信息
                                    var snlist = [String]()
                                    var tylist = [String]()
                                    var ltlist = [String]()
                                    var sdlist = [String]()
                                    for j in 0 ..< ProjectList![i]["StationList"].count {
                                        //print(j)
                                        //print(ProjectList![i]["StationList"][j]["StationName"])
                                        //站点名称
                                        let sn = ProjectList![i]["StationList"][j]["StationName"].stringValue
                                        snlist.append(sn)
                                        //站点状态
                                        let sd = ProjectList![i]["StationList"][j]["StationStatus"].stringValue
                                        sdlist.append(sd)
                                        //设备型号
                                        let type = ProjectList![i]["StationList"][j]["StationType"].stringValue
                                        tylist.append(type)
                                        //最新活跃时间StationLastTime
                                        let time = ProjectList![i]["StationList"][j]["StationLastTime"].stringValue
                                        ltlist.append(time)
                                    }
                                    stationNames.append(snlist)
                                    stationTypes.append(tylist)
                                    stationLastTime.append(ltlist)
                                    stationStations.append(sdlist)
                                }
                                sema.signal()
                            }else if getProjectsMessage["ResponseCode"] == "400"{
                                //若输入的密码格式错误，则返回400错误码，错误信息为“请输入正确的账号密码
                                print("400")
                                print(getProjectsMessage["ResponseMsg"],getProjectsMessage["ResponseCode"])
                                sema.signal()
                            }else{
                                //其他错误
                                print("其他错误qqqqqqqqqq")
                                print(getProjectsMessage["ResponseCode"])
                                print(getProjectsMessage["ResponseMsg"])
                                sema.signal()
                            }
                        case .failure(let error):
                            print(error)
                            sema.signal()
                        }
                   })
  
    }
}
