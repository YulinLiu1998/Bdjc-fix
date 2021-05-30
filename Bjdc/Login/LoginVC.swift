//
//  LoginVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var plaintTextDisplay: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    private var accountStr:String {account.unwrappedText }
    private var passwordStr:String {password.unwrappedText}
    override func viewDidLoad() {
        super.viewDidLoad()
        
        account.becomeFirstResponder()
        hideKeyboardWhenTappedAround()
        loginBtn.setToDisabled()
        password.isSecureBeginClear = false
        print("完成UI设计")
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    
    @IBAction func changeDisplayStatus(_ sender: UIButton) {
        print("之前：\(plaintTextDisplay.isSelected)")
        plaintTextDisplay.isSelected.toggle()
        print("之后：\(plaintTextDisplay.isSelected)")
        password.isSecureTextEntry = !plaintTextDisplay.isSelected
    }
   
    @IBAction func TFEditingChanged(_ sender: Any) {
        if accountStr.isPhoneNum && passwordStr.isPassword{
            loginBtn.setToEnabled()
        }else{
            loginBtn.setToDisabled()
        }
    }
    
        
    
    
    @IBAction func loginEvent(_ sender: UIButton) {
    performSegue(withIdentifier: "LoginToTabBar", sender: nil)
        

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
// MARK: - UITextFieldDelegate
extension LoginVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //range.location--当前输入的字符或粘贴文本的第一个字符的索引
        //string--当前输入的字符或粘贴的文本
        let limit = textField == account ? 11 : 16
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
