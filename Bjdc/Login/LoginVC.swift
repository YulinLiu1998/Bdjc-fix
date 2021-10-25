//
//  LoginVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
// qwerASD5 qwertyuiiopASDFG5*
// 每次登陆需要对比 账号是否发生改变，  否则 sesssion  token  报错
//        mLoginAccountEt.setText("AdminBDS");
//        mLoginCheckEt.setText("Beijing712*BDJC");
import UIKit
import MBProgressHUD
import SwiftDate
import RealmSwift


class LoginVC: UIViewController {
   
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var plaintTextDisplay: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var platformView: UIView!
    var accountStr:String {account.unwrappedText }
    var passwordStr:String {password.unwrappedText}
    var platformMenue:LMJDropdownMenu?
    var platformMenueTitles:Array<String>?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        account.becomeFirstResponder()
        hideKeyboardWhenTappedAround()
        password.isSecureBeginClear = false
        
        // MARK: 平台显示设置
        //平台显示与上次退出时选中的平台相同
        CurrentPlatform = realm.objects(PlatformSelectedTag.self).first?.PlatformSelectedTagIndex
        if CurrentPlatform == nil {
            CurrentPlatform = 1
            let platformSelectedTag =  PlatformSelectedTag()
            platformSelectedTag.PlatformSelectedTagIndex = CurrentPlatform!
            do{
                print("正在记录选中平台")
                try realm.write {
                    realm.add(platformSelectedTag)
                }
            }catch{
                print(error)
            }
        }
        //设置网络接口
        networkInterface = NetAPI[CurrentPlatform!]
        //平台选择
        dropdownMenuPlatform()
    }
    override func viewWillAppear(_ animated: Bool) {
        //记录选中工程，以便退出后初始化访问
       
        //进入工程后显示与上次退出时选中的工程相同
        CurrentProject = realm.objects(ProjectSelectedTag.self).first?.ProjectSelectedTagIndex
        if CurrentProject == nil {
            CurrentProject = 0
            let projectSelectedTag =  ProjectSelectedTag()
            projectSelectedTag.ProjectSelectedTagIndex = CurrentProject!
            do{
                print("正在记录选中工程")
                try realm.write {
                    realm.add(projectSelectedTag)
                }
            }catch{
                print(error)
            }
        }
        account.text = realm.objects(UserAccountReaml.self).first?.account
        password.text = realm.objects(UserAccountReaml.self).first?.password
        loginBtnStatues()
        if SessionInvalid{
            //Session 过期进入登陆界面
            //请求Token令牌
            accessToken()
            print("Session  过期进入登陆界面")
            //校验用户会话
            doSession()
        }else {
            //Session 未过期跳转主页面
            print("即将进入主页main")
            print("设置SessionToken")

            
            AccessToken = realm.objects(TokenRealm.self).first!.TokenString
            SessionUUID = realm.objects(SessionRealm.self).first!.SessionString
            print("请求工程数据")
            let workingGroup = DispatchGroup()
            let workingQueue = DispatchQueue(label: "request_AutoLogin")

            workingGroup.enter() // 开始
            workingQueue.async {
                    let sema = DispatchSemaphore(value: 0)
                    self.getProjects(sema: sema)
                    sema.wait() // 等待任务结束, 否则一直阻塞
                workingGroup.leave() // 结束
            }
            workingGroup.notify(queue: DispatchQueue.main) {
                // 全部调用完成后回到主线程,更新UI
                //请求数据错误处理
                guard AskProjectState else {
                    if AskProjectsCode == "400110" {
                        AskProjectsMessage = "访问错误，请重新登录"
                        self.view.showError(AskProjectsMessage!)
                        RedirectApp(VC: self)
                    }else{
                        self.view.showError(AskProjectsMessage!)
                    }
                    return
                }
                //更新Session有效期
                UpdateSessionAccessTime()
                let now = Date()
                // 创建一个日期格式器
                let dformatter = DateFormatter()
                dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                currentTime = dformatter.string(from: now)
                print("当前日期时间：\(dformatter.string(from: now))")
                self.performSegue(withIdentifier: "LoginToTabBar", sender: nil)
            }
        }
    }
    @IBAction func changeDisplayStatus(_ sender: UIButton) {
        print("之前：\(plaintTextDisplay.isSelected)")
        plaintTextDisplay.isSelected.toggle()
        print("之后：\(plaintTextDisplay.isSelected)")
        password.isSecureTextEntry = !plaintTextDisplay.isSelected
        
    }
   
    @IBAction func TFEditingChanged(_ sender: Any) {
        loginBtnStatues()
    }
    func loginBtnStatues() {
        if accountStr.isBlank == false && passwordStr.isBlank == false{
            loginBtn.setToEnabled()
        }else{
            loginBtn.setToDisabled()
        }
    }
    func saveRealmDatebase(){
        let userAccountReaml =  UserAccountReaml()
        userAccountReaml.account = Username!
        userAccountReaml.password = Password!
        userAccountReaml.LoginStatues = "true"
//        guard realm.objects(UserAccountReaml.self).filter("account = %@", Username!).count == 0 else {
//            print("用户信息已存在,只需更改用户状态")
//            do{
//                try realm.write {
//                    realm.objects(UserAccountReaml.self).first?.LoginStatues = "true"
//                }
//            }catch{
//                print(error)
//            }
//            return
//        }
        if realm.objects(UserAccountReaml.self).count != 0  {
            do{
                try realm.write {
                    realm.delete(realm.objects(UserAccountReaml.self).first!)
                }
            }catch{
                print(error)
            }
        }
        do{
            print("正在添加用户信息")
            try realm.write {
                realm.add(userAccountReaml)
            }
        }catch{
            print(error)
        }
    }
    
    @IBAction func loginPrepare(_ sender: Any) {
        DispatchQueue.main.async { [self] in
            Username = accountStr
            Password = passwordStr
        }
    }
    @IBAction func loginEvent(_ sender: UIButton) {
        
        guard SessionSuccess && TokenSuccess else {
            
            if TokenSuccess != true {
                let message = "Token数据错误，正在重新请求！"
                self.view.showError(message)
                //请求Token令牌
                accessToken()
            }else if SessionSuccess != true {
                let message = "Session数据错误，正在重新请求！"
                self.view.showError(message)
                //校验用户会话
                doSession()
            }
            return
        }
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: "request_queue")
        
        workingGroup.enter() // 开始
        workingQueue.async {
            let sema = DispatchSemaphore(value: 0)
            self.doLogin(sema: sema)
            sema.wait() // 等待任务结束, 否则一直阻塞
            workingGroup.leave() // 结束
        }

        workingGroup.enter() // 开始
        workingQueue.async {
            if LoginState {
                let sema = DispatchSemaphore(value: 0)
                self.getProjects(sema: sema)
                sema.wait() // 等待任务结束, 否则一直阻塞
            }
            workingGroup.leave() // 结束
        }
        workingGroup.notify(queue: DispatchQueue.main) { [self] in
            // 全部调用完成后回到主线程,更新UI
            //登录错误处理
            guard LoginState else {
                if LoginCode == "400110" {
                    LoginMessage = "访问错误，请重新登录"
                    self.view.showError(LoginMessage!)
                    RedirectApp(VC: self)
                }else{
                    self.view.showError(LoginMessage!)
                }
                return
            }
            //请求数据错误处理
            guard AskProjectState else {
                if AskProjectsCode == "400110" {
                    AskProjectsMessage = "访问错误，请重新登录"
                    self.view.showError(AskProjectsMessage!)
                    RedirectApp(VC: self)
                }else{
                    self.view.showError(AskProjectsMessage!)
                }
                return
            }
            //登录成功表明账号密码可行可以存储
            self.saveRealmDatebase()
            //更新Session有效期
            UpdateSessionAccessTime()
            let now = Date()
            // 创建一个日期格式器
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
            currentTime = dformatter.string(from: now)
            print("当前日期时间：\(dformatter.string(from: now))")
            self.performSegue(withIdentifier: "LoginToTabBar", sender: nil)
        }
        
    }
    
    @IBAction func privacyAgreement(_ sender: Any) {
        let urlString = "https://yulinliu1998.github.io/"
        let url = URL(string: urlString)!
        UIApplication.shared.open(url)
    }
    
}
// MARK: - UITextFieldDelegate
extension LoginVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //range.location--当前输入的字符或粘贴文本的第一个字符的索引
        //string--当前输入的字符或粘贴的文本
        let limit = textField == account ? 32 : 64
        let isExceed = range.location >= limit || (textField.unwrappedText.count + string.count) > limit
        if isExceed{
            showTextHUD("最多只能输入\(limit)位哦")
            print("您输入字符长度不满足要求")
        }
        return !isExceed
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == account{
            password.becomeFirstResponder()
        }else{
            if loginBtn.isEnabled{ loginEvent(loginBtn) }
        }
        return true
    }
}

