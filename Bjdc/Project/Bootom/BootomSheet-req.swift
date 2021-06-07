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
     
        showLoadHUD()
        AF.request("http://172.18.7.86/dist/API/getProjects.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                    self.hideLoadHUD()
                    switch response.result {
                        case .success(let value):
                            let getProjectsMessage = JSON(value)
                            if getProjectsMessage["ResponseCode"] == "200" {
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
                                    print("projectStationStatus",projectStationStatus)
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
                                        //print(j)
                                        //print(ProjectList![i]["StationList"][j]["StationName"])
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
                                //若输入的密码格式错误，则返回400错误码，错误信息为“请输入正确的账号密码
                                print("400")
                                print(getProjectsMessage["ResponseMsg"],getProjectsMessage["ResponseCode"])
                  
                            }else{
                                //其他错误
                                print("其他错误qqqqqqqqqq")
                                print(getProjectsMessage["ResponseCode"])
                                print(getProjectsMessage["ResponseMsg"])
                            }
                        case .failure(let error):
                            print(error)
                 
                        }
                   })
  
    }
}
