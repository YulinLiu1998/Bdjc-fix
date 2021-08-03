//
//  BootomSheet-req.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/4.
//

import Foundation
import Alamofire
import SwiftyJSON
extension BootomSheetVC{
    func getProjects(){
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID
        ]
        
        BootomSheetVC.showGlobalLoadHUD("正在更新工程数据")
        AF.request("\(networkInterface)getProjects.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: {  response in
                    BootomSheetVC.hideGlobalHUD()
                    switch response.result {
                        case .success(let value):
                            let getProjectsMessage = JSON(value)
                            if getProjectsMessage["ResponseCode"] == "200" {
                                //更新Session有效期
                                UpdateSessionAccessTime()
                                self.view.showSuccess("成功更新工程数据")
                                print("获取数据")
                                self.ProjectDateState = true
                                //获取项目列表
                                ProjectList = getProjectsMessage["ProjectList"]
                                //获取项目总数
                                ProjectNum = ProjectList?.count
                                for i in 0 ..< ProjectList!.count  {
                                    //MARK: -获取项目名字
                                    let name = ProjectList![i]["ProjectName"].stringValue
                                    projectTitles.append(name)
                                    //MARK: -获取工程站点状态
                                    let projectStationStatus:JSON = ProjectList![i]["ProjectStationStatus"]
                                    //警告
                                    let warning = projectStationStatus["Warning"].stringValue
                                    pssWarning.append(warning)
                                    //故障
                                    let Error = projectStationStatus["Error"].stringValue
                                    pssError.append(Error)
                                    //离线
                                    let Offline = projectStationStatus["Offline"].stringValue
                                    pssOffline.append(Offline)
                                    //在线
                                    let Online = projectStationStatus["Online"].stringValue
                                    pssOnline.append(Online)
                                    //总数
                                    let Total = projectStationStatus["Total"].stringValue
                                    pssTotal.append(Total)
                                    //MARK: -获取项目中站点信息
                                    var snlist = [String]()
                                    var tylist = [String]()
                                    var ltlist = [String]()
                                    var sdlist = [String]()
                                    for j in 0 ..< ProjectList![i]["StationList"].count {
                                        //站点名称
                                        let sn = ProjectList![i]["StationList"][j]["StationName"].stringValue
                                        snlist.append(sn)
                                        //站点状态
                                        let sd = ProjectList![i]["StationList"][j]["StationStatus"].stringValue
                                        sdlist.append(sd)
                                        //设备型号
                                        let type = ProjectList![i]["StationList"][j]["StationType"].stringValue
                                        tylist.append(type)
                                        //最新活跃时间StationLastTime
                                        let time = ProjectList![i]["StationList"][j]["StationLastTime"].stringValue
                                        ltlist.append(time)
                                    }
                                    stationNames.append(snlist)
                                    stationTypes.append(tylist)
                                    stationLastTime.append(ltlist)
                                    stationStatus.append(sdlist)
                                }
                            }else if getProjectsMessage["ResponseCode"] == "400"{
                                print("400")
                                self.ProjectDateStr = getProjectsMessage["ResponseMsg"].stringValue
                            }else{
                                //其他错误
                                if getProjectsMessage["ResponseCode"] == "400110"{
                                    RedirectApp(VC: self)
                                }
                                    
                                print("其他错误")
                                self.ProjectDateStr = getProjectsMessage["ResponseMsg"].stringValue
                            }
                        case .failure(let error):
                            print("error",error)
                            self.ProjectDateStr  = error.localizedDescription
                        }
                    //更新数据
                    self.updateData()
                   })
  
    }
   
    func getGraphicData1(){
        
    
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID,
                          "StationUUID":StationUUID,
                          "GraphicType":"GNSSFilterInfo",
                          "StartTime":StartTime,
                          "EndTime":EndTime,
                          "DeltaTime":"60"
        ]
        self.view.showLoad("正在加载图表")
        AF.request("\(networkInterface)getGraphicData.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    self.view.hideLoad()
                    switch response.result {
                        case .success(let value):
                            let GraphicData = JSON(value)
                            if GraphicData["ResponseCode"] == "200" {
                                //操作成功
                                //更新Session有效期
                                UpdateSessionAccessTime()
                                ChartData = GraphicData
                                self.tabBarController?.selectedIndex = 1
                            }else if GraphicData["ResponseCode"] == "400"{
                                //操作失败/参数非法
                                self.view.showError(GraphicData["ResponseCode"].stringValue)
                                print("\(GraphicData["ResponseCode"])")
                                print("\(GraphicData["ResponseMsg"])")
                               
                            }else{
                                self.view.showError(GraphicData["ResponseCode"].stringValue)
                                if GraphicData["ResponseCode"] == "400110"{
                                    RedirectApp(VC: self)
                                }
                                print("\(GraphicData["ResponseCode"])")
                                print("\(GraphicData["ResponseMsg"])")
                            }
                            
                        case .failure(let error):
                            print(error)
                            self.view.showError(error.localizedDescription)
                        }
                  
                   })
    }
}

extension BootomSheetVC:UITabBarControllerDelegate{
    
}
