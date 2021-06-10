//
//  TimeInterval.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/9.
//

import Foundation
extension BootomSheetChartVC{
    func DayTimeInterval(){
        TimeInterval_day.append("00:00")
        for i in 1..<1449 {
            if i%120 == 0 {
                let time = i/60
                if time >= 10 {
                    TimeInterval_day.append("\(time):00")
                }else{
                    TimeInterval_day.append("0\(time):00")
                }
            }else{
                TimeInterval_day.append("")
            }
        }
        TimeInterval_day.append("24:00")
    }

}
