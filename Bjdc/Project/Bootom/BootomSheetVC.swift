//
//  BootomSheetVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import UIKit
import FittedSheets
import SwiftyJSON
import SwiftDate
import LMJDropdownMenu

protocol UpdateMapView {
    func updateMapView()
    func removeAnnotationsMapView()
}
//ResizeSheetDelegate
class BootomSheetVC: UIViewController, Demoable {
    
    var sheetTable:SheetViewController?
    var delegate:UpdateMapView?
    //请求工程数据
    var ProjectDateState:Bool = false
    var ProjectDateStr:String?
    var ProjectDateCode:String?
    static var name: String { "bootomsheet" }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ContainerView: UIView!

    var _menu1OptionTitles:Array<String>?
    var navMenu1:LMJDropdownMenu?
    
    //当前标题
    var currentTitle: String?
    //列表行数
    var tableRows:Int = 0
    @IBOutlet weak var stationNums: UILabel!
    @IBOutlet weak var updateTime: UILabel!
    @IBOutlet weak var totalBtn: UIButton!
    @IBOutlet weak var onlineBtn: UIButton!
    @IBOutlet weak var warningBtn: UIButton!
    @IBOutlet weak var offlineBtn: UIButton!
    @IBOutlet weak var errorBtn: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    var Cell: DateTableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        //地图更新
        let Project = (storyboard?.instantiateViewController(identifier: "Project")) as! ProjectVC
        self.delegate = Project
        dropdownMenuBootomSheet()
        //初始化工程显示
        initProjectDisplay()
        totalBtn.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    override func viewWillAppear(_ animated: Bool) {
        if  pssTotal[CurrentProject!] != "" && pssTotal[CurrentProject!] != "0" {
            footerLabel.text = "当前工程站点信息已显示完全"
        }else{
            footerLabel.text = "当前工程未部署监测点！"
        }
        if tableFlage {
            NavMenu1?.title = projectTitles[CurrentProject!]
            //MARK: -监测点总数
            self.stationNums.text = pssTotal[CurrentProject!]
            //MARK: -btn
            let warning = NSAttributedString(string: "警告\n\(pssWarning[CurrentProject!])")
            warningBtn.setAttributedTitle(warning, for: .normal)
            let total = NSAttributedString(string: "总数\n\(pssTotal[CurrentProject!])")
            totalBtn.setAttributedTitle(total, for: .normal)
            let online = NSAttributedString(string: "在线\n\(pssOnline[CurrentProject!])")
            onlineBtn.setAttributedTitle(online, for: .normal)
            let offline = NSAttributedString(string: "离线\n\(pssOffline[CurrentProject!])")
            offlineBtn.setAttributedTitle(offline, for: .normal)
            let error = NSAttributedString(string: "故障\n\(pssError[CurrentProject!])")
            errorBtn.setAttributedTitle(error, for: .normal)
            
            showTotalData(totalBtn!)        }
    }
    //更新表单
    @IBAction func updateTimeEvent(_ sender: Any) {
        //获取数据
        getProjects()
    }
    
    @IBAction func showOnlineData(_ sender: Any) {
        //显示在线数据
        resizeButtonScale()
        onlineBtn.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        onlineData()
        
    }
    @IBAction func showTotalData(_ sender: Any) {
        //显示全部数据
        resizeButtonScale()
        totalBtn.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        totalData()
        
    }
    @IBAction func showWarningData(_ sender: Any) {
        //显示警告数据
        resizeButtonScale()
        warningBtn.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        warningData()
        
    }
    @IBAction func showErrorData(_ sender: Any) {
        //显示故障数据
        resizeButtonScale()
        errorBtn.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        errorData()
    }
    @IBAction func showOfflineData(_ sender: Any) {
        //显示离线数据
        resizeButtonScale()
        offlineBtn.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        offlineData()
       
    }
    func resizeButtonScale(){
        onlineBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
        totalBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
        warningBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
        offlineBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
        errorBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
    
    }
    static func openDemo(from parent: UIViewController, in view: UIView?) {
        let useInlineMode = view != nil
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "BootomSheet") as! BootomSheetVC
        sheet = SheetViewController(
            controller: controller,
            sizes: [.fixed(60), .fixed(200), .fixed(300), .fixed(450), .marginFromTop(50)],
            options: SheetOptions(useInlineMode: useInlineMode))
        
        sheet!.dismissOnPull = false
        sheet!.dismissOnOverlayTap = true
        sheet!.overlayColor = UIColor.clear
        sheet!.allowGestureThroughOverlay = true
        addSheetEventLogging(to: sheet!)
        
        if let view = view {
            sheet!.animateIn(to: view, in: parent)
        } else {
            parent.present(sheet!, animated: true, completion: nil)
        }
    }
//showBootomChart
    
    @IBAction func showData(_ sender: Any) {
        let btn = sender as! UIButton
        btnTag = btn.tag
        //TabBarJump = true
        currentDrodownTitle = currentTitle
        currenSelectedStation = stationNames[CurrentProject!][btn.tag]
        StationUUID = ProjectList![CurrentProject!]["StationList"][btn.tag]["StationUUID"].stringValue
        //设置请求时间
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
//    func resizeSheetHight() {
//
//        BootomSheetVC().sheetViewController?.resize(to: .fixed(150))
////            let storyboard = UIStoryboard(name: "Main", bundle: nil)
////            let controller = storyboard.instantiateViewController(identifier: "BootomSheet") as! BootomSheetVC
////            controller.sheetViewController!.resize(to: .fixed(200))
//            print("更改高度")
//
//    }
   
}

