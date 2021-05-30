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
    

    var Cell: DateTableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        dropdownMenuDateTable()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "position", for: indexPath) as! DateTableViewCell
        Cell = cell
        cell.positionTime.text = "2015-05-19 18:02:11"
        cell.positionKind.text = "基准站xxxxx"
        cell.positionStatus.tintColor = .green
        cell.positionModel.text = "4LC-\(indexPath.row)"
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

