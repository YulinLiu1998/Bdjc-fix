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
        //DestorySessionAccessTime()
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
}
