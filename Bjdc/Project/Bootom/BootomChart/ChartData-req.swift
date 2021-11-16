//
//  ChartData-req.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/8.
//

import Foundation
import Charts
import Alamofire
import SwiftyJSON
extension BootomSheetChartVC:UIDocumentInteractionControllerDelegate{
    func getFilterGraphicData(){
    
            let parameters = ["AccessToken":AccessToken,
                              "SessionUUID":SessionUUID,
                              "StationUUID":StationUUID,
                              "GraphicType":"GNSSFilterInfo",
                              "StartTime":StartTime,
                              "EndTime":EndTime,
                              "DeltaTime":DeltaTime[CurrentTimeInterval!]
            ]

            showLoadHUD("正在加载图表")
            AF.request("\(networkInterface)getGraphicData.php",
                       method: HTTPMethod.post,
                       parameters: parameters,
                       encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { [self] response in
                        self.hideLoadHUD()
                        switch response.result {
                            case .success(let value):
                                let GraphicData = JSON(value)
                                if GraphicData["ResponseCode"] == "200" {
                                    //操作成功
                                    //更新Session有效期
                                    UpdateSessionAccessTime()
                                    ChartData = GraphicData
                                    print(ChartData!["Content"].count)
                                    guard ChartData!["Content"].count != 0 else{
                                        chartView1.data = nil
                                        chartView2.data = nil
                                        chartView3.data = nil
                                        chartView4.data = nil
                                        chartView5.data = nil
                                        chartView6.data = nil
                                        NStackView.isHidden = true
                                        Ntips.isHidden = false
                                        EStackView.isHidden = true
                                        Etips.isHidden = false
                                        HStackView.isHidden = true
                                        Htips.isHidden = false
                                        Delta.isHidden = true
                                        DeltaTips.isHidden = false
                                        DetalHStackView.isHidden = true
                                        DetalHtips.isHidden = false
                                        HeartStackView.isHidden = true
                                        HeartTips.isHidden = false
                                        return
                                    }
                                    content = ChartData!["Content"]
                                    NStackView.isHidden = false
                                    Ntips.isHidden = true
                                    EStackView.isHidden = false
                                    Etips.isHidden = true
                                    HStackView.isHidden = false
                                    Htips.isHidden = true
                                    Delta.isHidden = false
                                    DeltaTips.isHidden = true
                                    DetalHStackView.isHidden = false
                                    DetalHtips.isHidden = true
                                    HeartStackView.isHidden = false
                                    HeartTips.isHidden = true
                                    //GNSSFilterInfoNCell
                                    print("GNSSFilterInfoNCell")
                                    updateN()
                                    NStart.text = StartTime
                                    Nend.text = EndTime
                                    //GNSSFilterInfoECell
                                    print("GNSSFilterInfoECell")
                                    updateE()
                                    EStart.text = StartTime
                                    Eend.text = EndTime
                                    //GNSSFilterInfoHCell
                                    print("GNSSFilterInfoHCell")
                                    updateH()
                                    Hstatr.text = StartTime
                                    Hend.text = EndTime
                                    //GNSSFilterInfoDeltaDCell
                                    print("GNSSFilterInfoDeltaDCell")
                                    updateDeltaD()
                                    DeltaDstatr.text = StartTime
                                    DeltaDend.text = EndTime
                                    //GNSSFilterInfoDeltaHCell
                                    print("GNSSFilterInfoDeltaHCell")
                                    updateDeltaH()
                                    DeltaHstatr.text = StartTime
                                    DeltaHend.text = EndTime
                                    //Heart
                                    Heart()
                                    HeartStart.text = StartTime
                                    HeartEnd.text = EndTime
                                    resetXScale()
                                }else if GraphicData["ResponseCode"] == "400"{
                                    //操作失败/参数非法
                                    self.view.showError(GraphicData["ResponseMsg"].stringValue)
                                    print("\(GraphicData["ResponseCode"])")
                                    print("\(GraphicData["ResponseMsg"])")
                                }else{
                                    self.view.showError(GraphicData["ResponseMsg"].stringValue)
                                    if GraphicData["ResponseCode"] == "400110"{
                                        RedirectApp(VC: self)
                                    }
                                    print("\(GraphicData["ResponseCode"])")
                                    print("\(GraphicData["ResponseMsg"])")
                                }
                                
                            case .failure(let error):
                                print(error)
                                self.view.showError("网络链接存在问题，无法获得图表数据！")
                            }
                      
                       })
    }
    
    func getStationReport()  {
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID,
                          "StationUUID":StationUUID,
                          "StartTime":StartTime,
                          "EndTime":EndTime
        ]
       
        BootomSheetChartVC.showGlobalLoadHUD("正在加载图表")
        AF.request("\(networkInterface)getStationReport.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
            BootomSheetChartVC.hideGlobalHUD()
                    switch response.result {
                        case .success(let value):
                            let StationReportMessage = JSON(value)
                            if StationReportMessage["ResponseCode"] == "200" {
                                //操作成功
                                //更新Session有效期
                                UpdateSessionAccessTime()
                                StationReport = StationReportMessage
                                let url = StationReport!["ReportFilePath"].stringValue
                                let fileName = url.subStringFrom(startIndex: url.positionOf(sub: "/", backwards: true))
                                let fileManager = FileManager.default
                                let filePath:String = NSHomeDirectory() + "/Documents" + fileName
                                let exist = fileManager.fileExists(atPath: filePath)
                                if exist {
                                    //删除已下载的
                                    try! fileManager.removeItem(atPath: filePath)
                                }
                                self.download(url: url)
                            }else if StationReportMessage["ResponseCode"] == "400"{
                                //操作失败/参数非法
                                print("\(StationReportMessage["ResponseMsg"])")
                                self.view.showError("\(StationReportMessage["ResponseMsg"])")
                            }else{
                                self.view.showError("下载失败请重试！2")
                                if StationReportMessage["ResponseCode"] == "400110"{
                                    RedirectApp(VC: self)
                                }
                                print("\(StationReportMessage["ResponseCode"])")
                                print("\(StationReportMessage["ResponseMsg"])")
                            }
                        case .failure(let error):
                            print("sdfasdf")
                            print(error)
                            self.view.showError("下载失败请重试！3")
                        }
                   })
    }
    func download(url:String)  {
        print("1")
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        //showLoadHUD()
        AF.download(url, to: destination).response {response in
            //self.hideLoadHUD()
            print("2")
            switch response.result {
            
                case .success(let value):
                    let alert = UIAlertController(title: "提示", message: "您要打开文件吗？", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "取消", style: .cancel)
                    let action2 = UIAlertAction(title: "确认", style: .default) { _ in
                        let docUrl = value?.absoluteURL
                        let documentController = UIDocumentInteractionController(url:docUrl!)
                        //let documentController = UIDocumentInteractionController(url:value!.absoluteURL)
                        documentController.delegate = self
                        documentController.presentPreview(animated: true)
                        documentController.presentOpenInMenu(from: self.exportBtn.frame, in: self.view, animated: true)
                        print("打开文件")
                    }
                    alert.addAction(action1)
                    alert.addAction(action2)
                    self.present(alert,animated: true)
                case .failure(let error):
                    
                    print("asdfasdfasdfasdfasdfasf",error)
                    if error.isDownloadedFileMoveError {
                        self.view.showInfo("当前报表已下载！")
                    }else {
                        self.view.showError("下载失败请重试！")
                    }
                   
            }
        }
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        //这个地方需要返回给一个控制器用于展现documentController在其上面，所以我们就返回当前控制器self
        return self
    }
}
