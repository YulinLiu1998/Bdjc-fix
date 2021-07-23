//
//  BootomSheet-btn.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/4.
//

import Foundation
extension BootomSheetVC{
    func updateData(){
        guard ProjectDateState else {
            if ProjectDateStr == nil { ProjectDateStr = "您的网络已断开！" }
            self.view.showErrorDetail("获取数据失败", ProjectDateStr!)
            ProjectDateState = false
            return
        }
        print("更新数据")
        let now = Date()
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        currentTime = dformatter.string(from: now)
        updateTime.text = currentTime
        //重置列表显示信息
        //CurrentProject = 0
        NavMenu1?.title = projectTitles[CurrentProject!]
        //MARK: -监测点总数
        self.stationNums.text = pssTotal[CurrentProject!]
        //MARK: -btn
        let warning = NSAttributedString(string: "警告\n\(pssWarning[CurrentProject!])")
        warningBtn.setAttributedTitle(warning, for: .normal)
        let total = NSAttributedString(string: "总数\n\(pssTotal[CurrentProject!])")
        totalBtn.setAttributedTitle(total, for: .normal)
        let online = NSAttributedString(string: "在线\n\(pssOnline[CurrentProject!])")
        onlineBtn.setAttributedTitle(online, for: .normal)
        let offline = NSAttributedString(string: "离线\n\(pssOffline[CurrentProject!])")
        offlineBtn.setAttributedTitle(offline, for: .normal)
        let error = NSAttributedString(string: "故障\n\(pssError[CurrentProject!])")
        errorBtn.setAttributedTitle(error, for: .normal)
        
        showTotalData(totalBtn!)
    }
    func onlineData(){
        //设置当前选中状态
        CurrentSelectedStatus = "Online"
        //设置当前选中状态的显示行数
        tableRows = Int(pssOnline[CurrentProject!])!
        for i in 0 ..< ProjectList!.count  {
            //MARK: -获取项目中站点信息
            var snlist = [String]()
            var tylist = [String]()
            var ltlist = [String]()
            var sslist = [String]()
            for j in 0 ..< ProjectList![i]["StationList"].count {
                //站点状态
                let ss = ProjectList![i]["StationList"][j]["StationStatus"].stringValue
                let status = Int(ss)
                if status! >= 10 && status! < 20 {
                    sslist.append(ss)
                    //站点名称
                    let sn = ProjectList![i]["StationList"][j]["StationName"].stringValue
                    snlist.append(sn)
                    
                    //设备型号
                    let type = ProjectList![i]["StationList"][j]["StationType"].stringValue
                    tylist.append(type)
                    //最新活跃时间StationLastTime
                    let time = ProjectList![i]["StationList"][j]["StationLastTime"].stringValue
                    ltlist.append(time)
                }
            }
            OnlineNames.append(snlist)
            OnlineTypes.append(tylist)
            OnlineLastTime.append(ltlist)
            OnlineStatus.append(sslist)
        }
        tableView.reloadData()
    }
    func totalData(){
        //设置当前选中状态
        CurrentSelectedStatus = "Total"
        //设置当前选中状态的显示行数
        tableRows = Int(pssTotal[CurrentProject!])!
        tableView.reloadData()
    }
    func warningData(){
        //设置当前选中状态
        CurrentSelectedStatus = "Warning"
        //设置当前选中状态的显示行数
        tableRows = Int(pssWarning[CurrentProject!])!
        for i in 0 ..< ProjectList!.count  {
            //MARK: -获取项目中站点信息
            var snlist = [String]()
            var tylist = [String]()
            var ltlist = [String]()
            var sslist = [String]()
            for j in 0 ..< ProjectList![i]["StationList"].count {
                //站点状态
                let ss = ProjectList![i]["StationList"][j]["StationStatus"].stringValue
                let status = Int(ss)
                if status! >= 30 && status! < 40 {
                    sslist.append(ss)
                    //站点名称
                    let sn = ProjectList![i]["StationList"][j]["StationName"].stringValue
                    snlist.append(sn)
                    
                    //设备型号
                    let type = ProjectList![i]["StationList"][j]["StationType"].stringValue
                    tylist.append(type)
                    //最新活跃时间StationLastTime
                    let time = ProjectList![i]["StationList"][j]["StationLastTime"].stringValue
                    ltlist.append(time)
                }
            }
            WarningNames.append(snlist)
            WarningTypes.append(tylist)
            WarningLastTime.append(ltlist)
            WarningStatus.append(sslist)
        }
        tableView.reloadData()
    }
    func errorData(){
        //设置当前选中状态
        CurrentSelectedStatus = "Error"
        //设置当前选中状态的显示行数
        tableRows = Int(pssError[CurrentProject!])!
        //获取站点信息
        for i in 0 ..< ProjectList!.count  {
            //MARK: -获取项目中站点信息
            var snlist = [String]()
            var tylist = [String]()
            var ltlist = [String]()
            var sslist = [String]()
            for j in 0 ..< ProjectList![i]["StationList"].count {
                //站点状态
                let ss = ProjectList![i]["StationList"][j]["StationStatus"].stringValue
                let status = Int(ss)
                if status! >= 40 && status! < 50 {
                    sslist.append(ss)
                    //站点名称
                    let sn = ProjectList![i]["StationList"][j]["StationName"].stringValue
                    snlist.append(sn)
                    
                    //设备型号
                    let type = ProjectList![i]["StationList"][j]["StationType"].stringValue
                    tylist.append(type)
                    //最新活跃时间StationLastTime
                    let time = ProjectList![i]["StationList"][j]["StationLastTime"].stringValue
                    ltlist.append(time)
                }
            }
            ErrorNames.append(snlist)
            ErrorTypes.append(tylist)
            ErrorLastTime.append(ltlist)
            ErrorStatus.append(sslist)
        }
        tableView.reloadData()
        
    }
    func offlineData(){
        //设置当前选中状态
        CurrentSelectedStatus = "Offline"
        //设置当前选中状态的显示行数
        tableRows = Int(pssOffline[CurrentProject!])!
        //站点信息
        for i in 0 ..< ProjectList!.count  {
            //MARK: -获取项目中站点信息
            var snlist = [String]()
            var tylist = [String]()
            var ltlist = [String]()
            var sslist = [String]()
            for j in 0 ..< ProjectList![i]["StationList"].count {
                //站点状态
                let ss = ProjectList![i]["StationList"][j]["StationStatus"].stringValue
                let status = Int(ss)
                if status! >= 20 && status! < 29 {
                    sslist.append(ss)
                    //站点名称
                    let sn = ProjectList![i]["StationList"][j]["StationName"].stringValue
                    snlist.append(sn)
                    
                    //设备型号
                    let type = ProjectList![i]["StationList"][j]["StationType"].stringValue
                    tylist.append(type)
                    //最新活跃时间StationLastTime
                    let time = ProjectList![i]["StationList"][j]["StationLastTime"].stringValue
                    ltlist.append(time)
                }
            }
            OfflineNames.append(snlist)
            OfflineTypes.append(tylist)
            OfflineLastTime.append(ltlist)
            OfflineStatus.append(sslist)
        }
        tableView.reloadData()
    }
}
