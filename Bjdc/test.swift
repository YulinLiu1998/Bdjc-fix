//
//  test.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/27.
//

import UIKit
import Alamofire
import SwiftyJSON
class test: UIViewController, UIDocumentInteractionControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backEvent(_ sender: Any) {
        //""
//        dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        let url = "https://httpbin.org/image/png"
        showLoadHUD()
        AF.download(url, to: destination).response {response in
            self.hideLoadHUD()
            switch response.result {
            
                case .success(let value):
                
                let alert = UIAlertController(title: "提示", message: "您要打开文件吗？", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "取消", style: .cancel)
                let action2 = UIAlertAction(title: "确认", style: .default) { _ in
                    let documentController = UIDocumentInteractionController(url:value!.absoluteURL)
                    documentController.delegate = self
                    //documentController.presentPreview(animated: true)
                    documentController.presentOpenInMenu(from: (sender as! UIButton).frame, in: self.view, animated: true)
                    print("打开文件")
                }
                alert.addAction(action1)
                alert.addAction(action2)
                self.present(alert,animated: true)
                case .failure(let error):
                    print(error)
            }
        }
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
