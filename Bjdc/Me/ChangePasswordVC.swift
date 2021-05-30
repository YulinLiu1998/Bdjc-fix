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
    
    private var originalPassword:String{ originalPasswordTF.unwrappedText}
    private var newPassword:String{ newPasswordTF.unwrappedText}
    private var confirmPassword:String{ confirmPasswordTF.unwrappedText}
    
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
        
        if newPassword.isPassword && !originalPassword.isPassword && confirmPassword.isPassword{
            if newPassword == confirmPassword  {
                //更新数据
                
                //返回上一页面
                self.navigationController?.popViewController(animated: true)
                
            }else{
                print("两次密码不一致")
            }
            
        }else{
            print("输入密码不符合规则")
        }
        
        
        
        
        
    }
    @IBAction func TFEditChanged(_ sender: Any){
        if originalPasswordTF.isBlank || confirmPasswordTF.isBlank || newPasswordTF.isBlank{
            done.isEnabled = false
        }else{
            done.isEnabled = true
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
