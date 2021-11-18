//
//  DocumentFileVC.swift
//  BDJC-Test
//
//  Created by mbp on 2021/10/26.
//

import UIKit

class DocumentFileVC: UIViewController,UIDocumentInteractionControllerDelegate {
    
    
    @IBOutlet weak var SelectedView: UIView!
    
    @IBOutlet weak var BackBtn: UIButton!
    
    @IBOutlet weak var tableview: UITableView!
    
    
    var OptionTitles:Array<String>?
    var navMenuDocument:LMJDropdownMenu?
    var AllFilesList:Array<String>?
    var contentsOfPath:Array<String>?
    override func viewDidLoad() {
        super.viewDidLoad()
        //documentSelectedInit()
      
        getAllFiles()
        // Do any additional setup after loading the view.
    }
    func addColorToShadow() {
        print("设置下划线")
         self.navigationController?.navigationBar.clipsToBounds = false
         self.navigationController?.navigationBar.shadowImage = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).image(CGSize(width: self.view.frame.width, height: 1))

    }
    func getAllFiles() {
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        contentsOfPath = try? manager.contentsOfDirectory(atPath: url.path)
        AllFilesList = contentsOfPath
       
        AllFilesList = AllFilesList?.filter({ temp in
            return temp.contains("xls")
        })
        
    }
    @IBAction func backEvent(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteFile(_ sender: Any) {
        let btn = sender as! UIButton
       
        
        let alert = UIAlertController(title: "提示", message: "您要删除文件吗？", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel)
        let action2 = UIAlertAction(title: "确认", style: .default) { [self]  _ in
            let manager = FileManager.default
            let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
            let url = urlForDocument[0]
             
            let toUrl = url.appendingPathComponent(contentsOfPath![btn.tag])
            // 删除文档根目录下的toUrl路径的文件（copyed.txt文件）
            
            try! manager.removeItem(at: toUrl)
            getAllFiles()
            tableview.reloadData()
            
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert,animated: true)
    }
    @IBAction func ShareFile(_ sender: Any) {
        let btn = sender as! UIButton
        // 定位到用户文档目录
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0]
         
        let toUrl = url.appendingPathComponent(contentsOfPath![btn.tag])
       
        let documentController = UIDocumentInteractionController(url:toUrl)
        documentController.delegate = self
        //documentController.presentPreview(animated: true)
        documentController.presentOpenInMenu(from: self.BackBtn.frame, in: self.view, animated: true)
    }
    @IBAction func CheckFile(_ sender: Any) {
        let btn = sender as! UIButton
        // 定位到用户文档目录
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0]
         
        let toUrl = url.appendingPathComponent(contentsOfPath![btn.tag])
       
        let documentController = UIDocumentInteractionController(url:toUrl)
        documentController.delegate = self
        documentController.presentPreview(animated: true)
        documentController.presentOpenInMenu(from: self.BackBtn.frame, in: self.view, animated: true)
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        //这个地方需要返回给一个控制器用于展现documentController在其上面，所以我们就返回当前控制器self
        return self
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DocumentFileVC:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
    
    func documentSelectedInit(){
        OptionTitles = ["全部"] + projectTitles
        
        
        navMenuDocument = LMJDropdownMenu.init()
        let frame =  CGRect(x: 50, y: 2, width: self.view.bounds.size.width-80, height: 40)
        navMenuDocument?.frame = frame
        navMenuDocument?.dataSource = self
        navMenuDocument?.delegate   = self
        
        navMenuDocument?.layer.borderUIColor = .black
        navMenuDocument?.layer.borderWidth  = 0
        navMenuDocument?.layer.cornerRadius = 0
        
        navMenuDocument?.title =  OptionTitles![0]
        navMenuDocument?.titleBgColor = .systemBackground
        navMenuDocument?.titleFont = .boldSystemFont(ofSize: 15)
        navMenuDocument?.titleColor = .label
        navMenuDocument?.titleAlignment = .center
        navMenuDocument?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        navMenuDocument?.rotateIcon = UIImage(systemName: "arrowtriangle.down.fill")!
        navMenuDocument?.rotateIconSize = CGSize(width: 15, height: 15)
        navMenuDocument?.rotateIconTint = .label
        navMenuDocument?.rotateIconMarginRight = 15;
        
        navMenuDocument?.optionBgColor = .systemBackground
        navMenuDocument?.optionFont = .systemFont(ofSize: 13)
        navMenuDocument?.optionTextColor = .label
        navMenuDocument?.optionTextAlignment = .center
        navMenuDocument?.optionNumberOfLines = 0
        navMenuDocument?.optionLineColor = .systemBackground
        navMenuDocument?.optionIconSize = CGSize(width: 15, height: 15)
        SelectedView.addSubview(navMenuDocument!)
    }
    
    //MARK: -LMJDropdownMenuDataSource
    
    func numberOfOptions(in menu: LMJDropdownMenu) -> UInt {
        return UInt(OptionTitles!.count)
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, heightForOptionAt index: UInt) -> CGFloat {
        return 30
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, titleForOptionAt index: UInt) -> String {
        return OptionTitles![Int(index)]
    }
    
    
    //MARK: -LMJDropdownMenuDelegate
    func dropdownMenu(_ menu: LMJDropdownMenu, didSelectOptionAt index: UInt, optionTitle title: String) {
        print("您选择了index：\(index),title: \(title)hhhhhhhhhhhhhhhhhh")
        
        tableview.reloadData()
    }
    
}
extension DocumentFileVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllFilesList!.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as! DocumentFileCell
        let name = AllFilesList![indexPath.row]
        //设备状态
        cell.fileName.text = name
        cell.deletItem.tag = (contentsOfPath?.firstIndex(of: name))!
        cell.check.tag = (contentsOfPath?.firstIndex(of: name))!
        cell.shareBtn.tag = (contentsOfPath?.firstIndex(of: name))!
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //删除数据
            let indexNumber = contentsOfPath?.firstIndex(of:  AllFilesList![indexPath.row])
            print("contentsOfPath![indexNumber!]",contentsOfPath![indexNumber!])
            let alertDelet = UIAlertController(title: "提示", message: "您要删除文件吗？", preferredStyle: .alert)
            let actionDelet1 = UIAlertAction(title: "取消", style: .cancel)
            let actionDelet2 = UIAlertAction(title: "确认", style: .default) { [self]  _ in
                let manager = FileManager.default
                let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
                let url = urlForDocument[0]

                let toUrl = url.appendingPathComponent(contentsOfPath![indexNumber!])
                // 删除文档根目录下的toUrl路径的文件（copyed.txt文件）

                try! manager.removeItem(at: toUrl)
                getAllFiles()
                tableview.reloadData()
            }
            alertDelet.addAction(actionDelet1)
            alertDelet.addAction(actionDelet2)
            self.present(alertDelet,animated: true)
           
            
        }
    }
    
    
}
extension DocumentFileVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
}
