//
//  ChartData-req.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/8.
//

import Foundation
import Alamofire
import SwiftyJSON
extension BootomSheetChartVC:UIDocumentInteractionControllerDelegate{
    func getFilterGraphicData(){
        
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID,
                          "StationUUID":StationUUID,
                          "StartTime":"00:00:00",
                          "EndTime":"23:59:59"
        ]
       
        showLoadHUD()
        AF.request("http://172.18.7.86/dist/API/getFilterGraphicData.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    self.hideLoadHUD()
                    switch response.result {
                        case .success(let value):
                            let GraphicData = JSON(value)
                            if GraphicData["ResponseCode"] == "200" {
                                //操作成功
                                print("GraphicData",GraphicData)
                            }else if GraphicData["ResponseCode"] == "400"{
                                //操作失败/参数非法
                                print("\(GraphicData["ResponseMsg"])")
                            }else{
                                print("\(GraphicData["ResponseCode"])")
                                print("\(GraphicData["ResponseMsg"])")
                            }
                        case .failure(let error):
                            print(error)
                        }
                   })
    }
    
    func getStationReport()  {
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID,
                          "StationUUID":StationUUID,
                          "StartTime":"00:00:00",
                          "EndTime":"23:59:59"
        ]
       
        showLoadHUD()
        AF.request("http://172.18.7.86/dist/API/getStationReport.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    self.hideLoadHUD()
                    switch response.result {
                        case .success(let value):
                            let StationReportMessage = JSON(value)
                            if StationReportMessage["ResponseCode"] == "200" {
                                //操作成功
                                StationReport = StationReportMessage
                                let url = StationReport!["ReportFilePath"].stringValue
                                self.download(url: url)
                            }else if StationReportMessage["ResponseCode"] == "400"{
                                //操作失败/参数非法
                                print("\(StationReportMessage["ResponseMsg"])")
                            }else{
                                print("\(StationReportMessage["ResponseCode"])")
                                print("\(StationReportMessage["ResponseMsg"])")
                            }
                        case .failure(let error):
                            print(error)
                        }
                   })
    }
    func download(url:String)  {
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
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
                    documentController.presentOpenInMenu(from: self.exportBtn.frame, in: self.view, animated: true)
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
}
