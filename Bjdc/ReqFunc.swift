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
//Token定时器
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
                        //请求token成功
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
                                    tokenAlert()
                                }
                            }
                            do{
                                print("正在添加Token")
                                try realm.write {
                                    realm.add(tokenRealm)
                                }
                            }catch{
                                print(error)
                                tokenAlert()
                            }
                        }else{
                            //请求token 错误 重定向至登陆页
                            tokenAlert()
                    
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                        tokenAlert()
                    }
               })
                
              
}
//token 弹出确认跳转框
func tokenAlert() {
    let vc = getCurrentViewController()
    let alert = UIAlertController(title: "提示", message: "您token更新失败，请重新登录！", preferredStyle: .alert)
    let action1 = UIAlertAction(title: "确认", style: .default) { _ in
        RedirectApp(VC: vc!)
    }
    alert.addAction(action1)
    vc!.present(alert,animated: true)
}

//更新Session有效期
func UpdateSessionAccessTime(){
    //realm.objects(SessionRealm.self)
    do{
        print("更新Session有效期")
        let date = Date()
        try realm.write {
            realm.objects(SessionRealm.self).first?.SessionAccessTime =  date + 1.hours
        }
    }catch{
        print(error)
    }
}
//使数据库中Session过期
func DestorySessionAccessTime(){
    //realm.objects(SessionRealm.self)
    do{
        print("使数据库中Session过期")
        SessionInvalid = true
        let date = Date()
        try realm.write {
            realm.objects(SessionRealm.self).first?.SessionAccessTime = date - 1.hours
            realm.objects(UserAccountReaml.self).first?.LoginStatues = "false"
        }
    }catch{
        print(error)
    }
}

func RedirectApp(VC:UIViewController){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(identifier: "LoginVCID") as! LoginVC
    VC.present(vc, animated: true, completion: nil)
    DestorySessionAccessTime()
}

func getCurrentViewController() -> UIViewController? {

    // If the root view is a navigation controller, we can just return the visible ViewController
    if let navigationController = getNavigationController() {

        return navigationController.visibleViewController
    }
    let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    // Otherwise, we must get the root UIViewController and iterate through presented views
    if let rootController = keyWindow?.rootViewController {

        var currentController: UIViewController! = rootController

        // Each ViewController keeps track of the view it has presented, so we
        // can move from the head to the tail, which will always be the current view
        while( currentController.presentedViewController != nil ) {

            currentController = currentController.presentedViewController
        }
        return currentController
    }
    return nil
}
// Returns the navigation controller if it exists
func getNavigationController() -> UINavigationController? {
    
    let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    if let navigationController = keyWindow?.rootViewController  {

        return navigationController as? UINavigationController
    }
    return nil
}
