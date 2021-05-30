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
    

    @IBOutlet weak var ContainerView: UIView!
    var _menu1OptionTitles:Array<String>?
    var _menu1OptionIcons:Array<String>?
    var navMenu1:LMJDropdownMenu?
    
    var currentTitle: String?

    var Cell: DateTableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        dropdownMenuBootomSheet()
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "position", for: indexPath) as! DateTableViewCell
        cell.positionTime.text = "2015-05-19 18:02:11"
        cell.positionKind.text = "基准站xxxxx"
        cell.positionStatus.tintColor = .green
        cell.positionModel.text = "4LC-\(indexPath.row)"
        cell.viewDataBtn.tag = indexPath.row
        return cell
    }
    
    
}

extension BootomSheetVC: UITableViewDelegate{
    
}

