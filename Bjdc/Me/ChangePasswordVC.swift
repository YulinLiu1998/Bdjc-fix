//
//  ChangePasswordVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/26.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var originalPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    var originalPassword:String{ originalPasswordTF.unwrappedText}
    var newPassword:String{ newPasswordTF.unwrappedText}
    var confirmPassword:String{ confirmPasswordTF.unwrappedText}
    
    @IBOutlet weak var done: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        originalPasswordTF.becomeFirstResponder()
    }
    @IBAction func backEvent(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //修改密码
    @IBAction func doneBtn(_ sender: UIButton) {
        
        view.endEditing(true)
        if newPassword.isPassword && originalPassword.isPassword && confirmPassword.isPassword{
            if newPassword == confirmPassword  {
                //更新数据
                setPassword()
            }else{
                view.showError("两次密码不一致,请重新输入！")
            }
        }else{
            print("输入密码不符合规则")
            var message:String?
            if !originalPassword.isPassword{
                message = "您输入的原密码不符合规则,请重新输入！"
            }else if !newPassword.isPassword{
                message = "您输入的新密码不符合规则,请重新输入！"
            }else if !confirmPassword.isPassword {
                message = "您输入的确认密码不符合规则,请重新输入！"
            }
            view.showError(message!)
        }
        
        
        
        
        
    }
    @IBAction func TFEditChanged(_ sender: Any){
        if originalPasswordTF.isBlank || confirmPasswordTF.isBlank || newPasswordTF.isBlank{
            done.isEnabled = false
        }else{
            done.isEnabled = true
        }
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

}

extension ChangePasswordVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case originalPasswordTF:
            newPasswordTF.becomeFirstResponder()
        case newPasswordTF:
            confirmPasswordTF.becomeFirstResponder()
        default:
            if done.isEnabled {
                doneBtn(done)
            }
        }
        
        return true
    }
}
