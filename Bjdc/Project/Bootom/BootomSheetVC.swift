//
//  BootomSheetVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import UIKit
import FittedSheets
import SwiftyJSON
protocol UpdateMapView {
    func updateMapView(city:String)
}
class BootomSheetVC: UIViewController, Demoable {
    
    
    var delegate:UpdateMapView!
    static var name: String { "bootomsheet" }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ContainerView: UIView!
    var _menu1OptionTitles:Array<String>?
    var _menu1OptionIcons:Array<String>?
    var navMenu1:LMJDropdownMenu?
    
    //当前标题
    var currentTitle: String?
    //列表行数
    var tableRows:Int?
    @IBOutlet weak var stationNums: UILabel!
    @IBOutlet weak var updateTime: UILabel!
    @IBOutlet weak var totalBtn: UIButton!
    @IBOutlet weak var onlineBtn: UIButton!
    @IBOutlet weak var warningBtn: UIButton!
    @IBOutlet weak var offlineBtn: UIButton!
    @IBOutlet weak var errorBtn: UIButton!
    var Cell: DateTableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        let Project = (storyboard?.instantiateViewController(identifier: "Project")) as! ProjectVC
        self.delegate = Project
        dropdownMenuBootomSheet()
        //初始化工程显示
        initProjectDisplay()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
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
    
    @IBAction func updateTimeEvent(_ sender: Any) {
        
        updateData()
    }
    
    @IBAction func showOnlineData(_ sender: Any) {
        //显示在线数据
        onlineData()
        
    }
    @IBAction func showTotalData(_ sender: Any) {
        //显示全部数据
        totalData()
        
    }
    @IBAction func showWarningData(_ sender: Any) {
        //显示警告数据
        warningData()
        
    }
    @IBAction func showErrorData(_ sender: Any) {
        //显示故障数据
        errorData()
    }
    @IBAction func showOfflineData(_ sender: Any) {
        //显示离线数据
        offlineData()
       
    }
    static func openDemo(from parent: UIViewController, in view: UIView?) {
        let useInlineMode = view != nil
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "BootomSheet") as! BootomSheetVC
       
        let sheet = SheetViewController(
            controller: controller,
            sizes: [.fixed(200), .fixed(300), .fixed(450), .marginFromTop(50)],
            options: SheetOptions(useInlineMode: useInlineMode))
        
        sheet.dismissOnPull = false
        sheet.dismissOnOverlayTap = false
        
        sheet.overlayColor = UIColor.clear
        sheet.allowGestureThroughOverlay = true
        addSheetEventLogging(to: sheet)
        
        if let view = view {
            sheet.animateIn(to: view, in: parent)
        } else {
            parent.present(sheet, animated: true, completion: nil)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as! BootomSheetChartVC
//        let vc = segue.destination as! ChartTableVC
        let btn = sender as! UIButton
        vc.test = "\(btn.tag)BDJC"
        vc.currentDrodownTitle = currentTitle
        
    }
    

}
