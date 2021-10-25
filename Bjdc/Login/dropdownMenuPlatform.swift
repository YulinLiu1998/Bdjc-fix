//
//  dropdownMenuPlatform.swift
//  BDJC-Test
//
//  Created by mbp on 2021/9/15.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
extension LoginVC {
    func dropdownMenuPlatform() {
        platformMenueTitles = ["第一平台","第二平台","第三平台","海淀平台"]
        platformMenue = LMJDropdownMenu.init()
        let frame =  CGRect(x: 0, y: 0, width: self.platformView.bounds.size.width, height: 40)
        platformMenue?.frame = frame
        platformMenue?.dataSource = self
        platformMenue?.delegate   = self
        
        platformMenue?.layer.borderUIColor = .black
        platformMenue?.layer.borderWidth  = 0
        platformMenue?.layer.cornerRadius = 0
        
        platformMenue?.backgroundColor = .purple
        platformMenue?.title = platformMenueTitles![CurrentPlatform!]
        platformMenue?.titleBgColor = .systemBackground
        platformMenue?.titleFont = .boldSystemFont(ofSize: 18)
        platformMenue?.titleColor = .label
        platformMenue?.titleAlignment = .justified
        platformMenue?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        platformMenue?.rotateIcon = UIImage(systemName: "arrowtriangle.down.fill")!
        platformMenue?.rotateIconTint = .label
        platformMenue?.rotateIconSize = CGSize(width: 15, height: 15);
        platformMenue?.rotateIconMarginRight = 15;
        
        platformMenue?.optionBgColor = .systemBackground
        platformMenue?.optionFont = .systemFont(ofSize: 16)
        platformMenue?.optionTextColor = .label
        platformMenue?.optionTextAlignment = .left
        platformMenue?.optionNumberOfLines = 0
        platformMenue?.optionLineColor = .systemBackground
        platformMenue?.optionIconSize = CGSize(width: 15, height: 15)
        
        
        platformView.addSubview(platformMenue!)
        
    }
}
extension LoginVC:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
    func numberOfOptions(in menu: LMJDropdownMenu) -> UInt {
        return UInt(platformMenueTitles!.count)
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, heightForOptionAt index: UInt) -> CGFloat {
        return 30
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, titleForOptionAt index: UInt) -> String {
        return platformMenueTitles![Int(index)]
    }
    
    //MARK: -LMJDropdownMenuDelegate
    func dropdownMenu(_ menu: LMJDropdownMenu, didSelectOptionAt index: UInt, optionTitle title: String)  {
        print("您选择了index：\(index),title: \(title)")
        if index == 0 {
            //第一平台，南京
            networkInterface = FIRST_BASE_URL
        }else if index == 1 {
            //第二平台，北京和平里，实验室
            networkInterface = SECOND_BASE_URL
        }else if index == 2 {
            //第三平台，测试
            networkInterface = THIRD_BASE_URL
        }else if index == 3 {
            //第四平台，海淀
            networkInterface = FOURTH_BASE_URL
        }
        
        CurrentPlatform = Int(index)
        try? realm.write {
            realm.objects(PlatformSelectedTag.self).first?.PlatformSelectedTagIndex = CurrentPlatform!
        }
        
        print("更换接口 accessToken   dosession 重新请求")
        SessionUUID = "00000000-0000-0000-0000-000000000000"
        
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: "request_updateTokenSession")
        
        workingGroup.enter() // 开始
        workingQueue.async {
            let sema = DispatchSemaphore(value: 0)
            self.TokenRE(sema: sema)
            sema.wait() // 等待任务结束, 否则一直阻塞
            workingGroup.leave() // 结束
        }

        workingGroup.enter() // 开始
        workingQueue.async {
            let sema = DispatchSemaphore(value: 0)
            self.SessionRE(sema: sema)
            sema.wait() // 等待任务结束, 否则一直阻塞
            workingGroup.leave() // 结束
        }

        
    }
    
    func TokenRE(sema: DispatchSemaphore){

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
                            print(tokenMessage["ResponseCode"],"正常请求token")
                            print(tokenMessage["ResponseMsg"])
                            if tokenMessage["ResponseCode"] == "200" {
                                TokenSuccess = true
                                AccessToken = tokenMessage["AccessToken"].stringValue
                                ExpireTimestamp = tokenMessage["ExpireTimestamp"].int
                                //TokenRealm
                                let tokenRealm = TokenRealm()
                                tokenRealm.TokenString = AccessToken!
                                print("AccessToken",AccessToken as Any)
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
                                sema.signal()
                            }else{
                                print(tokenMessage["ResponseCode"])
                                print(tokenMessage["ResponseMsg"])
                                TokenSuccess = false
                                sema.signal()
                            }
                            
                            
                        case .failure(let error):
                            TokenSuccess = false
                            print(error)
                        sema.signal()
                        }
                   })
                    
                  
    }
    func SessionRE(sema: DispatchSemaphore){
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID,
        ]
        AF.request("\(networkInterface)doSession.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    switch response.result {
                        case .success(let value):
                            let doSessionMessage = JSON(value)
                            print(doSessionMessage["ResponseCode"],"session")
                            print(doSessionMessage["ResponseMsg"],"session")
                            if doSessionMessage["ResponseCode"] == "202" {
                                //未登录时
                                SessionSuccess = true
                                SessionUUID = doSessionMessage["SessionUUID"].stringValue
                                print("SessionUUID",SessionUUID as Any)
                                sema.signal()
                                //SessionUUIDmd5 = SessionUUID.md5
                                //sessionRealm
                                self.UpdateSessionReaml()
                            }else if doSessionMessage["ResponseCode"] == "201"{
                                //已登录时
                                SessionSuccess = true
                                self.UpdateSessionReaml()
                                print("\(doSessionMessage["UserName"])")
                                sema.signal()
                            }else{
                                SessionSuccess = false
                                sema.signal()
                            }
                        case .failure(let error):
                            print(error)
                            SessionSuccess = false
                            sema.signal()
                        }
                   })
                    
    }
}
