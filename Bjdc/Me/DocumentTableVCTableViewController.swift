//
//  DocumentTableVCTableViewController.swift
//  BDJC-Test
//
//  Created by mbp on 2021/10/29.
//

import UIKit

class DocumentTableVCTableViewController: UITableViewController {
    
    var OptionTitles:Array<String>?
    var navMenuDocument:LMJDropdownMenu?
    var AllFilesList:Array<String>?
    var contentsOfPath:Array<String>?
    
    
    @IBOutlet weak var BackBtn: UIBarButtonItem!
    
    @IBOutlet weak var Edit: UIBarButtonItem!
    @IBOutlet weak var DeletMu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        getAllFiles()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        DeletMu.isEnabled = isEditing
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func backBtn(_ sender: Any) {
        navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editButtonItem.title = isEditing ? "完成" : "编辑"
        DeletMu.isEnabled = isEditing
    }
    
    @IBAction func DeletSelect(_ sender: Any) {
        if isEditing {
            if let indexPaths = tableView.indexPathsForSelectedRows{
                print("indexPaths",indexPaths)
                //批量删除
                let manager = FileManager.default
                let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
                let url = urlForDocument[0]

                for indexPath in indexPaths {
                    let indexNumber = contentsOfPath?.firstIndex(of:  AllFilesList![indexPath.row])
                    let toUrl = url.appendingPathComponent(contentsOfPath![indexNumber!])
                    try! manager.removeItem(at: toUrl)
                }

                getAllFiles()
                tableView.reloadData()
            }
        }
    }
    //获取文件进行显示
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
    
    
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AllFilesList!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as! DocumentFileCell
        let name = AllFilesList![indexPath.row]
        //设备状态
        cell.fileName.text = name
        cell.deletItem.tag = (contentsOfPath?.firstIndex(of: name))!
        cell.check.tag = (contentsOfPath?.firstIndex(of: name))!
        cell.shareBtn.tag = (contentsOfPath?.firstIndex(of: name))!
        return cell

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
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
                tableView.reloadData()
            }
            alertDelet.addAction(actionDelet1)
            alertDelet.addAction(actionDelet2)
            self.present(alertDelet,animated: true)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DocumentTableVCTableViewController:UIDocumentInteractionControllerDelegate {
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
            tableView.reloadData()
            
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
        documentController.presentOpenInMenu(from: self.navigationController!.accessibilityFrame, in: self.view, animated: true)
        
        
        
        
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
        documentController.presentOpenInMenu(from: self.navigationController!.accessibilityFrame, in: self.view, animated: true)
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        //这个地方需要返回给一个控制器用于展现documentController在其上面，所以我们就返回当前控制器self
        return self
    }
}
