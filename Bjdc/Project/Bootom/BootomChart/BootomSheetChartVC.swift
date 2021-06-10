//
//  BootomSheetChartVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/26.
//

import UIKit

class BootomSheetChartVC: UITableViewController {

    //var stationUUID:String?
    var test:String?
    var TimeInterval_day = [String]()
    var TimeInterval_week = [String]()
    var TimeInterval_month = [String]()
    var TimeInterval_year = [String]()
    var TimeInterval_Moreyears = [String]()
    var currentDrodownTitle:String?
    var nameDropdownTitles:Array<String>?
    var nameDropdown:LMJDropdownMenu?
    var dateDropdownTitles:Array<String>?
    var dateDropdown:LMJDropdownMenu?
    @IBOutlet weak var chartTitle: UILabel!
    @IBOutlet weak var Ntest: UILabel!
    @IBOutlet weak var exportBtn: UIButton!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var HeaderView: UIView!
    
    @IBOutlet weak var GNSSFilterInfoNCell: UIView!
    @IBOutlet weak var NstartTime: UILabel!
    @IBOutlet weak var NendTime: UILabel!
    
    @IBOutlet weak var GNSSFilterInfoECell: UIView!
    @IBOutlet weak var EstatrTime: UILabel!
    @IBOutlet weak var EendTime: UILabel!
    
    @IBOutlet weak var GNSSFilterInfoHCell: UIView!

    
    
    @IBOutlet weak var GNSSFilterInfoDeltaD: UIView!
    
    
    @IBOutlet weak var GNSSFilterInfoDeltaHCell:
        UIView!
    
    
    @IBOutlet weak var HeartCell: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DayTimeInterval()
       
            //初始化站点名称下拉菜单
            dropdownName()
            //初始化日期选择下拉菜单
            dropdownDate()
            //GNSSFilterInfoNCell
//            GNSSFilterInfoN()
//            //GNSSFilterInfoECell
//            GNSSFilterInfoE()
//            //GNSSFilterInfoHCell
//            GNSSFilterInfoH()
//            //GNSSFilterInfoDeltaDCell
//            GNSSFilterInfoDeltaDD()
//            //GNSSFilterInfoDeltaHCell
//            GNSSFilterInfoDeltaH()
//            //Heart
//            Heart()
       
        chartTitle.text = currentDrodownTitle
        Ntest.text = test
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    @IBAction func backEvent(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func exportFile(_ sender: Any) {
        getStationReport()
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

            let vc = segue.destination as! ChartTableVC
            let btn = sender as! UIButton
            vc.test = "\(btn.tag)BDJC"
//            vc.currentNavgationTitle = currentTitle

        
            
        
    }
*/

}
