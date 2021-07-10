//
//  AlertView.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/7/8.
//


import Foundation
import PGDatePicker
class AlertView: UIView{
    
    @IBOutlet weak var Startbtn: UIButton!
    @IBOutlet weak var Endbtn: UIButton!
    var startTimeString:String?
    var endTimeString:String?
    var flage:String?
    override func awakeFromNib() {
        super.awakeFromNib()
        applyLayout()
    }
    
    private func applyLayout() {
        Startbtn.setTitleColor(.systemGray, for: .normal)
        if CustomStartTime != nil{
            Startbtn.setTitle(CustomStartTime, for: .normal)
        }else{
            Startbtn.setTitle("请输入开始时间", for: .normal)
        }
        Endbtn.setTitleColor(.systemGray, for: .normal)
        if CustomEndTime != nil{
            Endbtn.setTitle(CustomEndTime, for: .normal)
        }else{
            Endbtn.setTitle("请输入结束时间", for: .normal)
        }
        
    }
    
    @IBAction func SetStartTime(_ sender: Any) {
        flage = "start"
        let datePickerManagerStart = PGDatePickManager()
        let datePickerStart = datePickerManagerStart.datePicker!
        datePickerStart.delegate = self
        datePickerStart.datePickerMode = .dateHour
        let vc = nextresponsder(viewself: self)
        vc.present(datePickerManagerStart, animated: false, completion: nil)
        
    }
    
    @IBAction func SetEndTime(_ sender: Any) {
        flage = "end"
        let datePickerManagerEnd = PGDatePickManager()
        let datePickerEnd = datePickerManagerEnd.datePicker!
        datePickerEnd.delegate = self
        datePickerEnd.datePickerMode = .dateHour
        let vc = nextresponsder(viewself: self)
        vc.present(datePickerManagerEnd, animated: false, completion: nil)
    }
    
    func nextresponsder(viewself:UIView)->UIViewController{
           var vc:UIResponder = viewself
        
           while vc.isKind(of: UIViewController.self) != true {
               vc = vc.next!
           }
           return vc as! UIViewController
       }
       


    class func instantiateFromNib() -> AlertView {
        return Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)!.first as! AlertView
    }
}

extension AlertView: PGDatePickerDelegate {
    
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
            Startbtn.setTitle(startTimeString, for: .normal)
            CustomStartTime = startTimeString
            dateStartComponents = dateComponents!
        }else{
            endTimeString = "\(year)-\(month)-\(day) \(hour):00:00"
            Endbtn.setTitle(endTimeString, for: .normal)
            CustomEndTime = endTimeString
            dateEndComponents = dateComponents!
        }
    }
}
