//
//  customAlert.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/25.
//

import Foundation
import PGDatePicker
class customAlert: UIView{

    
    
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    var startTimeString:String?
    var endTimeString:String?
    var flage:String?
    override func awakeFromNib() {
        super.awakeFromNib()
        applyLayout()
    }
    
    private func applyLayout() {
        startTimeTextField.placeholder = "请您输入开始时间"
        endTimeTextField.placeholder = "请您输入结束时间"
    }
    func nextresponsder(viewself:UIView)->UIViewController{
           var vc:UIResponder = viewself
        
           while vc.isKind(of: UIViewController.self) != true {
               vc = vc.next!
           }
           return vc as! UIViewController
       }
       


    class func instantiateFromNib() -> customAlert {
        return Bundle.main.loadNibNamed("customAlert", owner: nil, options: nil)!.first as! customAlert
    }
}
extension customAlert:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let datePickerManager = PGDatePickManager()
        let datePicker = datePickerManager.datePicker!
        datePicker.delegate = self
        datePicker.datePickerMode = .dateHour
        let vc = nextresponsder(viewself: self)
        vc.present(datePickerManager, animated: false, completion: nil)
        if textField == startTimeTextField {
            flage = "start"
        }else{
            flage = "end"
        }
        return true
    }
}
extension customAlert: PGDatePickerDelegate {
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        print("dateComponents = ", dateComponents!)
        let year = String(dateComponents.year!)
        let m = dateComponents.month
        let month =  m! >= 10 ? String(m!) : ("0" + String(m!))
        let d = dateComponents.day
        let day =  d! >= 10 ? String(d!) : ("0" + String(d!))
        let h = dateComponents.hour
        let hour =  h! >= 10 ? String(h!) : ("0" + String(h!))
        if flage == "start"{
            startTimeString = "\(String(describing: year))-\(month)-\(day) \(hour):00:00"
            startTimeTextField.text = startTimeString
            CustomStartTime = startTimeString
            dateStartComponents = dateComponents!
        }else{
            endTimeString = "\(year)-\(month)-\(day) \(hour):00:00"
            endTimeTextField.text = endTimeString
            CustomEndTime = endTimeString
            dateEndComponents = dateComponents!
        }
        startTimeTextField.resignFirstResponder()
        endTimeTextField.resignFirstResponder()
    }
}
