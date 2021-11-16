//
//  MeVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/26.
//

import UIKit

class MeVC: UIViewController {

    @IBOutlet weak var UserName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        if Username == nil {
            Username = realm.objects(UserAccountReaml.self).first?.account
        }
        UserName.text = Username
    }
    
    @IBAction func toInfo(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "PersonalInfoVC") as! PersonalInfo
        navigationController?.pushViewController(vc, animated: true)
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
