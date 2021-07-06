//
//  DateTableVC-req.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/11.
//

import Foundation
import Alamofire
import SwiftyJSON
extension DateTableVC{
    func getGraphicData(){
        
        let parameters = ["AccessToken":AccessToken,
                          "SessionUUID":SessionUUID,
                          "StationUUID":StationUUID,
                          "GraphicType":"GNSSFilterInfo",
                          "StartTime":StartTime,
                          "EndTime":EndTime,
                          "DeltaTime":"60"
        ]
        //showLoadHUD("正在加载图表")
        AF.request("\(networkInterface)getGraphicData.php",
                   method: HTTPMethod.post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).responseJSON(completionHandler: { response in
                  //  self.hideLoadHUD()
                    switch response.result {
                        case .success(let value):
                            let GraphicData = JSON(value)
                            if GraphicData["ResponseCode"] == "200" {
                                //操作成功
                                ChartData = GraphicData
                               
                                self.performSegue(withIdentifier: "viewData", sender: nil)
                                //self.tabBarController?.selectedIndex = 1
                                //let vc = self.storyboard?.instantiateViewController(withIdentifier: "DateTableChart") as! DateTableVC
                                //vc.performSegue(withIdentifier: "viewData", sender: nil)
                            }else if GraphicData["ResponseCode"] == "400"{
                                //操作失败/参数非法
                                print("\(GraphicData["ResponseCode"])")
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
}
