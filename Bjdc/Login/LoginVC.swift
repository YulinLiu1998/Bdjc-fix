//
//  LoginVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//


import UIKit
import MBProgressHUD
class LoginVC: UIViewController {
   
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var plaintTextDisplay: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    var accountStr:String {account.unwrappedText }
    var passwordStr:String {password.unwrappedText}
    override func viewDidLoad() {
        super.viewDidLoad()
        CurrentProject = 0
        //请求Token令牌
        accessToken()
        
        
        account.becomeFirstResponder()
        hideKeyboardWhenTappedAround()
        //loginBtn.setToDisabled()
        password.isSecureBeginClear = false
    }
    override func viewWillAppear(_ animated: Bool) {
        //校验用户会话
        doSession()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        //获取工程项目列表
       // getProjects()
        
    }
    @IBAction func changeDisplayStatus(_ sender: UIButton) {
        print("之前：\(plaintTextDisplay.isSelected)")
        plaintTextDisplay.isSelected.toggle()
        print("之后：\(plaintTextDisplay.isSelected)")
        password.isSecureTextEntry = !plaintTextDisplay.isSelected
        
    }
   
    @IBAction func TFEditingChanged(_ sender: Any) {
        if accountStr.isAccount && passwordStr.isPassword{
            loginBtn.setToEnabled()
        }else{
            loginBtn.setToDisabled()
        }
    }
    
        
    
    
    @IBAction func loginEvent(_ sender: UIButton) {
        //doLogin()
        //getProjects()
        DispatchQueue.main.async{
            self.showTextHUD("请稍等")
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
            let sema = DispatchSemaphore(value: 0)
            self.getProjects(sema: sema)
            sema.wait() // 等待任务结束, 否则一直阻塞
            workingGroup.leave() // 结束
        }
        workingGroup.notify(queue: DispatchQueue.main) {
            // 全部调用完成后回到主线程,更新UI
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
// MARK: - UITextFieldDelegate
extension LoginVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //range.location--当前输入的字符或粘贴文本的第一个字符的索引
        //string--当前输入的字符或粘贴的文本
        let limit = textField == account ? 32 : 64
        let isExceed = range.location >= limit || (textField.unwrappedText.count + string.count) > limit
        if isExceed{
            //showTextHUD("最多只能输入\(limit)位哦")
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
