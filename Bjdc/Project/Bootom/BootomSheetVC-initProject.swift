//
//  BootomSheetVC-initProject.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/4.
//

import Foundation

extension BootomSheetVC{
    func initProjectDisplay(){
        //MARK: -初始化
        //设置当前工程项目索引
        CurrentProject = 0
        //设置当前选中状态
        CurrentSelectedStatus = "Total"
        //设置当前选中状态的显示行数
        tableRows = Int(pssTotal[CurrentProject!])!
        //监测点总数
        stationNums.text = pssTotal[0]
        //更新时间
        updateTime.text = currentTime
        //btn 操作
        warningBtn.titleLabel?.textAlignment = .center
        totalBtn.titleLabel?.textAlignment = .center
        onlineBtn.titleLabel?.textAlignment = .center
        offlineBtn.titleLabel?.textAlignment = .center
        errorBtn.titleLabel?.textAlignment = .center
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
    }
}
