//
//  BootomSheet-TableView.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/4.
//

import Foundation

extension BootomSheetVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "position", for: indexPath) as! DateTableViewCell
        
        if CurrentSelectedStatus == "Total"{
            //设备状态
            let status = Int(stationStatus[CurrentProject!][indexPath.row])
            var color:UIColor?
            if status! >= 10 && status! < 20{
                color = .green //正常
            }else if status! >= 20 && status! < 29{
                color = .gray  //离线
            }else if status! >= 30 && status! < 39{
                color = .yellow //警告
            }else {
                color = .red  //故障
            }
            cell.positionStatus.tintColor = color
            //设备最后更新时间
            cell.positionTime.text = stationLastTime[CurrentProject!][indexPath.row]
            //设备类型
            cell.positionKind.text =
                stationTypes[CurrentProject!][indexPath.row] == "1" ? "基准站":"移动站"
           
            //设备名字
            cell.positionModel.text = stationNames[CurrentProject!][indexPath.row]
        }else if CurrentSelectedStatus == "Online"{
            //设备状态
            cell.positionStatus.tintColor = .green
            //设备最后更新时间
            cell.positionTime.text = OnlineLastTime[CurrentProject!][indexPath.row]
            //设备类型
            cell.positionKind.text =
                OnlineTypes[CurrentProject!][indexPath.row] == "1" ? "基准站":"移动站"
           
            //设备名字
            cell.positionModel.text = OnlineNames[CurrentProject!][indexPath.row]
        }else if CurrentSelectedStatus == "Error"{
            //设备状态
            cell.positionStatus.tintColor = .red
            //设备最后更新时间
            cell.positionTime.text = ErrorLastTime[CurrentProject!][indexPath.row]
            //设备类型
            cell.positionKind.text =
                ErrorTypes[CurrentProject!][indexPath.row] == "1" ? "基准站":"移动站"
           
            //设备名字
            cell.positionModel.text = ErrorNames[CurrentProject!][indexPath.row]
        }else if CurrentSelectedStatus == "Warning"{
            //设备状态
            cell.positionStatus.tintColor = .yellow
            //设备最后更新时间
            cell.positionTime.text = WarningLastTime[CurrentProject!][indexPath.row]
            //设备类型
            cell.positionKind.text =
                WarningTypes[CurrentProject!][indexPath.row] == "1" ? "基准站":"移动站"
           
            //设备名字
            cell.positionModel.text = WarningNames[CurrentProject!][indexPath.row]
        }else if CurrentSelectedStatus == "Offline"{
            //设备状态
            cell.positionStatus.tintColor = .gray
            //设备最后更新时间
            cell.positionTime.text = OfflineLastTime[CurrentProject!][indexPath.row]
            //设备类型
            cell.positionKind.text =
                OfflineTypes[CurrentProject!][indexPath.row] == "1" ? "基准站":"移动站"
           
            //设备名字
            cell.positionModel.text = OfflineNames[CurrentProject!][indexPath.row]
        }
        let stationIndex:Int?
        stationIndex = stationNames[CurrentProject!].firstIndex(of:cell.positionModel.text! )
        cell.viewDataBtn.tag = stationIndex!
        return cell
    }
    
    
}

extension BootomSheetVC: UITableViewDelegate{
    
}

