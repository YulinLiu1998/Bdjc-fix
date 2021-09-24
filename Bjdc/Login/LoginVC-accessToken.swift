//
//  LoginVC-accessToken.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/31.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
import CryptoSwift
extension LoginVC{
    func accessToken(){

        let parameters = ["GrantType":"BDJC",
                          "AppID":"UzHky82L6hOKCAsI5MBQYImw",
                          "AppSecret":"HCarvgfeeCQlFoWfo8lylh7aF61wNNBjv8FriEw"
        ]
        //showLoadHUD()
        AF.request("\(networkInterface)getAccessToken.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    //self.hideLoadHUD()
                    switch response.result {
                        case .success(let value):
                            let tokenMessage = JSON(value)
                            print(tokenMessage["ResponseCode"],"token")
                            print(tokenMessage["ResponseMsg"])
                            if tokenMessage["ResponseCode"] == "200" {
                                TokenSuccess = true
                                AccessToken = tokenMessage["AccessToken"].stringValue
                                ExpireTimestamp = tokenMessage["ExpireTimestamp"].int
                                //TokenRealm
                                let tokenRealm = TokenRealm()
                                tokenRealm.TokenString = AccessToken!
                                //若TokenRealm数据库中存在值，则将其删除后再添加，保证数据库只有一个值（保证Token唯一性）
                                if realm.objects(TokenRealm.self).count != 0{
                                    do{
                                        try realm.write {
                                            realm.delete(realm.objects(TokenRealm.self).first!)
                                        }
                                    }catch{
                                        print(error)
                                    }
                                }
                                do{
                                    print("正在添加Token")
                                    try realm.write {
                                        realm.add(tokenRealm)
                                    }
                                }catch{
                                    print(error)
                                }
                            }else{
                                print(tokenMessage["ResponseCode"])
                                print(tokenMessage["ResponseMsg"])
                                TokenSuccess = false
                            }
                            
                            
                        case .failure(let error):
                            TokenSuccess = false
                            print(error)
                        }
                   })
                    
                  
    }
    func doSession(){
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID,
        ]
       // showLoadHUD()
        
        AF.request("\(networkInterface)doSession.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                   // self.hideLoadHUD()
                    switch response.result {
                        case .success(let value):
                            let doSessionMessage = JSON(value)
                            print(doSessionMessage["ResponseCode"],"session")
                            print(doSessionMessage["ResponseMsg"],"session")
                            if doSessionMessage["ResponseCode"] == "202" {
                                //未登录时
                                SessionSuccess = true
                                SessionUUID = doSessionMessage["SessionUUID"].stringValue
                                //SessionUUIDmd5 = SessionUUID.md5
                                //sessionRealm
                                self.UpdateSessionReaml()
                            }else if doSessionMessage["ResponseCode"] == "201"{
                                //已登录时
                                SessionSuccess = true
                                self.UpdateSessionReaml()
                                print("\(doSessionMessage["UserName"])")
                            }else{
                                SessionSuccess = false
                            }
                        case .failure(let error):
                            print(error)
                            SessionSuccess = false
                        }
                   })
                    
    }
    func UpdateSessionReaml() {
        let sessionRealm = SessionRealm()
        sessionRealm.SessionString = SessionUUID
        //若sessionRealm数据库中存在值，则将其删除后再添加，保证数据库只有一个值（保证Token唯一性）
        if realm.objects(SessionRealm.self).count != 0{
            do{
                try realm.write {
                    realm.delete(realm.objects(SessionRealm.self).first!)
                }
            }catch{
                print(error)
            }
        }
        do{
            print("正在添加Session")
            try realm.write {
                realm.add(sessionRealm)
            }
        }catch{
            print(error)
        }
    }
    func doLogin(sema: DispatchSemaphore){
        SessionUUIDmd5 = SessionUUID.md5()
        let key = SessionUUIDmd5?.lowercased()
        let iv = key![24...]
        let text = Password
        var encryptText:String?
        encryptText = text!.tripleDESEncryptOrDecrypt(op: CCOperation(kCCEncrypt), key: key!, iv: iv)

        
        
        
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID,
                          "Username":Username,
                          "Password":encryptText
        ]
        DispatchQueue.main.async{
           self.showLoadHUD("正在登录")
        }
        AF.request("\(networkInterface)doLogin.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    self.hideLoadHUD()
                    switch response.result {
                        case .success(let value):
                            let loginMessage = JSON(value)
                            LoginMessage = loginMessage["ResponseMsg"].stringValue
                            LoginCode = loginMessage["ResponseCode"].stringValue
                            print("loginMessage",loginMessage)
                            if loginMessage["ResponseCode"] == "200" {
                                //成功
                                LoginState = true
                                sema.signal()
                            }else if loginMessage["ResponseCode"] == "400"{
                                //若输入的密码格式错误，则返回400错误码，错误信息为“请输入正确的账号密码
                                LoginState = false
                                sema.signal()
                                print("400")
                                print(loginMessage["ResponseMsg"],loginMessage["ResponseCode"])
                            }else{
                                LoginState = false
                                sema.signal()
                                //其他错误
                                print("其他错误loginMessage")
                                print(loginMessage["ResponseCode"])
                                print(loginMessage["ResponseMsg"])
                            }
                        case .failure(let error):
                            LoginMessage = "网络链接存在问题，无法登陆！"
                            print(error)
                            LoginState = false
                            sema.signal()
                        }
                   })
       
                    
    }
    func getProjects(sema: DispatchSemaphore){
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID
        ]
        DispatchQueue.main.async{
          self.showLoadHUD("正在获取工程数据")
        }
        AF.request("\(networkInterface)getProjects.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    self.hideLoadHUD()
                    switch response.result {
                        case .success(let value):
                            let getProjectsMessage = JSON(value)
                            AskProjectsMessage = getProjectsMessage["ResponseMsg"].stringValue
                            AskProjectsCode = getProjectsMessage["ResponseCode"].stringValue
                            if getProjectsMessage["ResponseCode"] == "200" {
                                AskProjectState = true
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
                                    var longitudeList = [String]()
                                    var latitudeList = [String]()
                                    for j in 0 ..< ProjectList![i]["StationList"].count {
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
                                        //经度
                                        let longitude = ProjectList![i]["StationList"][j]["StationLongitude"].stringValue
                                        if longitude != ""{
                                            longitudeList.append(longitude)
                                        }
                                        //纬度
                                        let latitude = ProjectList![i]["StationList"][j]["StationLatitude"].stringValue
                                        if latitude != "" {
                                            latitudeList.append(latitude)
                                        }
                                    }
                                    stationNames.append(snlist)
                                    stationTypes.append(tylist)
                                    stationLastTime.append(ltlist)
                                    stationStatus.append(sdlist)
                                    StationLongitudes.append(longitudeList)
                                    StationLatitudes.append(latitudeList)
                                }
                                sema.signal()
                            }else if getProjectsMessage["ResponseCode"] == "400"{
                                //若输入的密码格式错误，则返回400错误码，错误信息为“请输入正确的账号密码
                                AskProjectState = false
                                print("400")
                                print(getProjectsMessage["ResponseMsg"],getProjectsMessage["ResponseCode"])
                                sema.signal()
                            }else{
                                //其他错误
                                AskProjectState = false
                                print("其他错误getProjects")
                                print(getProjectsMessage["ResponseCode"])
                                print(getProjectsMessage["ResponseMsg"])
                                sema.signal()
                            }
                        case .failure(let error):
                            AskProjectState = false
                            AskProjectsMessage = "网络链接存在问题，无法登陆！"
                            print(error)
                            sema.signal()
                        }
                   })
  
    }
}
