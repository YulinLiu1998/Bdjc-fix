//
//  DateSheetVC.swift
//  BDJC-Test
//
//  Created by mbp on 2021/10/12.
//

import UIKit
import SwiftDate
import LMJDropdownMenu

class DateSheetVC: UIViewController {

 
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ContainerView: UIView!

    var _menu1OptionTitles:Array<String>?
    var navMenu2:LMJDropdownMenu?
    
    //当前标题
    var currentTitle: String?
    //列表行数
    var tableRows:Int = 0
    @IBOutlet weak var footerLabel: UILabel!
    var Cell: DateTableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        DateSheetTable()
    }
    override func viewWillAppear(_ animated: Bool) {
        if TabBarJump {
            
            let vc =  self.storyboard?.instantiateViewController(withIdentifier: "BootomSheetChart") as! BootomSheetChartVC
            self.navigationController?.pushViewController(vc, animated: false)
        }else {
            NavMenu?.title = projectTitles[CurrentProject!]
            tableView.reloadData()
        }
        
        
        if  pssTotal[CurrentProject!] != "" && pssTotal[CurrentProject!] != "0" {
            footerLabel.text = "当前工程站点信息已显示完全"
        }else{
            footerLabel.text = "当前工程未部署监测点！"
        }
        
    }
    
    @IBAction func showData(_ sender: Any) {
        let btn = sender as! UIButton
        btnTag = btn.tag
       
        currentDrodownTitle = currentTitle
        currenSelectedStation = stationNames[CurrentProject!][btn.tag]
        StationUUID = ProjectList![CurrentProject!]["StationList"][btn.tag]["StationUUID"].stringValue
        var  date = Date()
        date = Date.dateFromGMT(date)
        print(date.toFormat("yyyy-MM-dd"))
        StartTime = "\(date.toFormat("yyyy-MM-dd")) 00:00:00"
        EndTime = "\(date.toFormat("yyyy-MM-dd")) 23:59:59"
        TimeInterval_day = [String]()
        DayTimeInterval()
        CurrentTimeInterval = 3
        TimeIntervalKind[CurrentTimeInterval!] = TimeInterval_day
        self.getGraphicData()
    }
    func DayTimeInterval(){
        var date = Date()
        date = date.dateAt(.startOfDay)
        TimeDateInterval = [String]()
        for i in 0..<1440 {
            if i%120 == 0 {
                let time = i/60
                if time >= 10 {
                    TimeInterval_day.append("\(time):00")
                }else{
                    TimeInterval_day.append("0\(time):00")
                }
            }else{
                TimeInterval_day.append("")
            }
            TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
            date = date + 1.minutes
        }
        TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
        TimeInterval_day.append("24:00")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func DateSheetTable() {
      
        _menu1OptionTitles = projectTitles
        print("_menu1OptionTitles",projectTitles)
        
        navMenu2 = LMJDropdownMenu.init()
        NavMenu2 = navMenu2
        let frame =  CGRect(x: 40, y: 2, width: self.view.bounds.size.width-80, height: 40)
        navMenu2?.frame = frame
        navMenu2?.dataSource = self
        navMenu2?.delegate   = self
        
        navMenu2?.layer.borderUIColor = .black
        navMenu2?.layer.borderWidth  = 0
        navMenu2?.layer.cornerRadius = 0
        
        navMenu2?.title =  NavMenu1!.title
        currentTitle = navMenu2?.title
        navMenu2?.titleBgColor = .systemBackground
        navMenu2?.titleFont = .boldSystemFont(ofSize: 15)
        navMenu2?.titleColor = .label
        navMenu2?.titleAlignment = .center
        navMenu2?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        navMenu2?.rotateIcon = UIImage(systemName: "arrowtriangle.down.fill")!
        navMenu2?.rotateIconSize = CGSize(width: 15, height: 15)
        navMenu2?.rotateIconTint = .label
        navMenu2?.rotateIconMarginRight = 15;
        
        navMenu2?.optionBgColor = .systemBackground
        navMenu2?.optionFont = .systemFont(ofSize: 13)
        navMenu2?.optionTextColor = .label
        navMenu2?.optionTextAlignment = .center
        navMenu2?.optionNumberOfLines = 0
        navMenu2?.optionLineColor = .systemBackground
        navMenu2?.optionIconSize = CGSize(width: 15, height: 15)
        ContainerView.addSubview(navMenu2!)
    }

}

extension DateSheetVC:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
    
    //MARK: -LMJDropdownMenuDataSource
    
    func numberOfOptions(in menu: LMJDropdownMenu) -> UInt {
        return UInt(_menu1OptionTitles!.count)
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, heightForOptionAt index: UInt) -> CGFloat {
        return 30
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, titleForOptionAt index: UInt) -> String {
        return _menu1OptionTitles![Int(index)]
    }
    
    
    //MARK: -LMJDropdownMenuDelegate
    func dropdownMenu(_ menu: LMJDropdownMenu, didSelectOptionAt index: UInt, optionTitle title: String) {
        print("您选择了index：\(index),title: \(title)hhhhhhhhhhhhhhhhhh")
        currentTitle = title
        //MARK: -当前工程索引
        CurrentProject = Int(index)
        try? realm.write {
            realm.objects(ProjectSelectedTag.self).first?.ProjectSelectedTagIndex = CurrentProject!
        }
        //MARK: -标题
        currentTitle = title
        tableView.reloadData()
    }
    
}
extension DateSheetVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(pssTotal[CurrentProject!])!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "position", for: indexPath) as! DateTableViewCell
        //设备状态
        let status = Int(stationStatus[CurrentProject!][indexPath.row])
        var color:UIColor?
        if status! >= 10 && status! < 20{
            color = .green //正常
        }else if status! >= 20 && status! < 29{
            color = .gray  //离线
        }else if status! >= 30 && status! < 39{
            color = .yellow //警告
        }else {
            color = .red  //故障
        }
        cell.positionStatus.tintColor = color
        //设备最后更新时间
        cell.positionTime.text = stationLastTime[CurrentProject!][indexPath.row]
        //设备类型
        cell.positionKind.text =
            stationTypes[CurrentProject!][indexPath.row] == "1" ? "基准站":"移动站"
       
        //设备名字
        cell.positionModel.text = stationNames[CurrentProject!][indexPath.row]
        let stationIndex:Int?
        stationIndex = stationNames[CurrentProject!].firstIndex(of:cell.positionModel.text! )
        cell.viewDataBtn.tag = stationIndex!
        return cell
    }
    
    
}
