//
//  DateTableVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import UIKit

class DateTableVC: UITableViewController {
  
    var _menu1OptionTitles:Array<String>?
    var _menu1OptionIcons:Array<String>?
    var navMenu:LMJDropdownMenu?
    
    var currentTitle: String?
    
    var tableRows:Int?
    var Cell: DateTableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableFlage = true
        dropdownMenuDateTable()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if tableFlage {
            NavMenu?.title = projectTitles[CurrentProject!]
            tableView.reloadData()
        }
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
        cell.viewDataBtn.tag = indexPath.row
        return cell
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "viewData" {
            let vc = segue.destination as! ChartTableVC
            let btn = sender as! UIButton
            vc.test = "\(btn.tag)BDJC"
            vc.currentNavgationTitle = currentTitle
//            let cell = sender as! DateTableViewCell
//            let row = tableView.indexPath(for: cell)!.row
//            vc.test = "\(sender.tag)"
            
        }
    }

}

