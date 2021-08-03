//
//  DateTableVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import UIKit
import SwiftDate
class DateTableVC: UITableViewController {
  
    var _menu1OptionTitles:Array<String>?
    var _menu1OptionIcons:Array<String>?
    var navMenu:LMJDropdownMenu?
    var btnTag:Int?
    var currentTitle: String?
    
    var tableRows:Int?
    var Cell: DateTableViewCell?
    
    @IBOutlet weak var footerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableFlage = true
        //dropdownMenuDateTable()
    }
    override func viewWillAppear(_ animated: Bool) {
        dropdownMenuDateTable()
        if TabBarJump {
            
            let vc =  self.storyboard?.instantiateViewController(withIdentifier: "BootomSheetChart") as! BootomSheetChartVC
            self.navigationController?.pushViewController(vc, animated: false)
        }else {
            if tableFlage {
                NavMenu?.title = projectTitles[CurrentProject!]
                tableView.reloadData()
            }
        }
        if  pssTotal[CurrentProject!] != "" && pssTotal[CurrentProject!] != "0" {
            footerLabel.text = "当前工程站点信息已显示完全"
        }else{
            footerLabel.text = "当前工程未部署监测点！"
        }
        self.navigationController?.isNavigationBarHidden = false
        
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
        DispatchQueue.main.async {
            self.showTextHUD("正在加载")
        }
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
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Int(pssTotal[CurrentProject!])!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
//        if segue.identifier == "viewData" {
//            let vc = segue.destination as! ChartTableVC
//            let btn = sender as! UIButton
//            vc.test = "\(btn.tag)BDJC"
//            vc.currentNavgationTitle = currentTitle
//
//
//        }
    }

}

