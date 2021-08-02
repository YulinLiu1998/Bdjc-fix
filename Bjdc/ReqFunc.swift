//
//  ReqFunc.swift
//  Bjdc
//
//  Created by mbp on 2021/7/26.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
import SwiftDate
func accessTokenTimer(){

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
                        if tokenMessage["ResponseCode"] == "200" {
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
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                    }
               })
                
              
}
func UpdateSessionAccessTime(){
    //realm.objects(SessionRealm.self)
    do{
        print("更新Session有效期")
        let date = Date()
        print("session",realm.objects(SessionRealm.self).first?.SessionAccessTime)
        try realm.write {
            realm.objects(SessionRealm.self).first?.SessionAccessTime =  date + 1.hours
        }
        print("session",realm.objects(SessionRealm.self).first?.SessionAccessTime)
    }catch{
        print(error)
    }
}
func DestorySessionAccessTime(){
    //realm.objects(SessionRealm.self)
    do{
        print("使Session过期")
        print("session",realm.objects(SessionRealm.self).first?.SessionAccessTime)
        print("LoginStatues",realm.objects(UserAccountReaml.self).first?.LoginStatues)
        let date = Date()
        try realm.write {
            realm.objects(SessionRealm.self).first?.SessionAccessTime = date - 1.hours
            realm.objects(UserAccountReaml.self).first?.LoginStatues = "false"
        }
        print("session",realm.objects(SessionRealm.self).first?.SessionAccessTime)
        print("LoginStatues",realm.objects(UserAccountReaml.self).first?.LoginStatues)
    }catch{
        print(error)
    }
}
