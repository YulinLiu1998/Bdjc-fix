//
//  PersonalInfo.swift
//  Bjdc
//
//  Created by mbp on 2021/8/4.
//

import UIKit
import SwiftyJSON
class PersonalInfo: UIViewController {
    
    var UserList:JSON?
    var InfoMessage:String?
    var InfoCode:String?
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var trueName: UILabel!
    @IBOutlet weak var documentType: UILabel!
    @IBOutlet weak var documentNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: "request_PersonalInfo")
        
        workingGroup.enter() // 开始
        workingQueue.async {
            print("1")
            let sema = DispatchSemaphore(value: 0)
            self.getUserInformation(sema: sema)
            sema.wait() // 等待任务结束, 否则一直阻塞
            workingGroup.leave() // 结束
        }
        workingGroup.notify(queue: DispatchQueue.main) { [self] in
            // 全部调用完成后回到主线程,更新UI

            guard self.InfoCode == "200" else {
                if InfoCode == "400110" {
                    self.view.showError("会话过期，请重新登录！")
                    RedirectApp(VC: self)
                }else{
                    self.view.showError(InfoMessage!)
                }
                return
            }
            self.updateInfo()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func updateInfo(){
        if let UserList = UserList{
            userName.text = UserList[0]["UserName"].stringValue
            phoneNumber.text = UserList[0]["UserMobile"].stringValue
            email.text = UserList[0]["UserEmail"].stringValue
            trueName.text = UserList[0]["UserRealName"].stringValue
            var cardType = ""
            let CardType = UserList[0]["UserCardType"].stringValue
            if CardType == "10"{
                cardType = "居民身份证"
            }else if CardType == "11"{
                cardType = "居民户口簿"
            }else if CardType == "13"{
                cardType = "军官证"
            }else if CardType == "20"{
                cardType = "港澳台通行证"
            }else if CardType == "30"{
                cardType = "外国护照"
            }
            documentType.text = cardType
            documentNumber.text = UserList[0]["UserIdCard"].stringValue
        }else{
            userName.text = "获取失败"
            phoneNumber.text = "获取失败"
            email.text = "获取失败"
            trueName.text = "获取失败"
            documentType.text = "获取失败"
            documentNumber.text = "获取失败"
            self.view.showError("用户数据获取失败！")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
