//
//  Setting.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/26.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON
class Setting: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backEvent(_ sender: Any) {
        
//        dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        
        
        doLogout()
        DestorySessionAccessTime()
        //返回登陆页面的方法1
        //let vc = storyboard?.instantiateViewController(identifier: "LoginVCID") as! LoginVC
        // vc.hidesBottomBarWhenPushed = true
        // self.navigationController?.pushViewController(vc, animated: true)
        //返回登陆页面的方法2 由登陆页面present而来 dismiss 之后 会返回
        //注销登录操作
    }
    
    func WarningAlert( alertTitle:String = "提示",  alertContent:String){
        let alert = UIAlertController(title: alertTitle, message: alertContent, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "确认", style: .cancel)
        
        alert.addAction(action1)
        self.present(alert,animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func accessToken(){

        let parameters = ["GrantType":"BDJC",
                          "AppID":"UzHky82L6hOKCAsI5MBQYImw",
                          "AppSecret":"HCarvgfeeCQlFoWfo8lylh7aF61wNNBjv8FriEw"
        ]
        showLoadHUD()
        AF.request("\(networkInterface)getAccessToken.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    self.hideLoadHUD()
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
    func doSession(){
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID,
        ]
        showLoadHUD()
        
        AF.request("\(networkInterface)doSession.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    self.hideLoadHUD()
                    switch response.result {
                        case .success(let value):
                            let doSessionMessage = JSON(value)
                            if doSessionMessage["ResponseCode"] == "202" {
                                //未登录时
                                SessionUUID = doSessionMessage["SessionUUID"].stringValue
                                //SessionUUIDmd5 = SessionUUID.md5
                                //sessionRealm
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
                            }else if doSessionMessage["ResponseCode"] == "201"{
                                //已登录时
                                print("\(doSessionMessage["UserName"])")
                            }
                        case .failure(let error):
                            print(error)
                        }
                   })
                    
    }
}
