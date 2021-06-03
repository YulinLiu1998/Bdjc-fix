//
//  BootomSheetVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import UIKit
import FittedSheets

class BootomSheetVC: UIViewController, Demoable {
    static var name: String { "bootomsheet" }
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ContainerView: UIView!
    var _menu1OptionTitles:Array<String>?
    var _menu1OptionIcons:Array<String>?
    var navMenu1:LMJDropdownMenu?
    
    var currentTitle: String?

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
        dropdownMenuBootomSheet()
        
        CurrentProject = 0
        stationNums.text = pssTotal[0]
        updateTime.text = currentTime
        warningBtn.titleLabel?.textAlignment = .center
        totalBtn.titleLabel?.textAlignment = .center
        onlineBtn.titleLabel?.textAlignment = .center
        offlineBtn.titleLabel?.textAlignment = .center
        errorBtn.titleLabel?.textAlignment = .center
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
    }
    
    @IBAction func updateTimeEvent(_ sender: Any) {
        let now = Date()
         
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        currentTime = dformatter.string(from: now)
        updateTime.text = currentTime
        
    }
    
    @IBAction func showOnlineData(_ sender: Any) {
        //显示在线数据
    }
    @IBAction func showTotalData(_ sender: Any) {
        //显示全部数据
    }
    @IBAction func showWarningData(_ sender: Any) {
        //显示警告数据
    }
    @IBAction func showErrorData(_ sender: Any) {
        //显示故障数据
    }
    @IBAction func showOfflineData(_ sender: Any) {
        //显示离线数据
    }
    static func openDemo(from parent: UIViewController, in view: UIView?) {
        let useInlineMode = view != nil
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "BootomSheet") as! BootomSheetVC
        let controller = storyboard.instantiateViewController(identifier: "BootomSheet") as! BootomSheetVC
       
        let sheet = SheetViewController(
            controller: controller,
            sizes: [.fixed(200), .fixed(300), .fixed(450), .marginFromTop(50)],
            options: SheetOptions(useInlineMode: useInlineMode))
        
        sheet.dismissOnPull = false
        sheet.dismissOnOverlayTap = false
        
        sheet.overlayColor = UIColor.clear
        
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
        
//        vc.currentNavgationTitle = currentTitle
    }
    

}

extension BootomSheetVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(pssTotal[CurrentProject!])! 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "position", for: indexPath) as! DateTableViewCell
        //cell.positionTime.text = "2015-05-19 18:02:11"
        cell.positionTime.text = stationLastTime[CurrentProject!][indexPath.row]
        
        cell.positionKind.text =
            stationTypes[CurrentProject!][indexPath.row] == "1" ? "基准站":"移动站"
        
        cell.positionStatus.tintColor = stationStations[CurrentProject!][indexPath.row] == "20" ? UIColor.green : UIColor.gray
        
        cell.positionModel.text = stationNames[CurrentProject!][indexPath.row]
        cell.viewDataBtn.tag = indexPath.row
        return cell
    }
    
    
}

extension BootomSheetVC: UITableViewDelegate{
    
}

