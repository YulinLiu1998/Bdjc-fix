//
//  TimeInterval.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/9.
//
import SwiftDate
import Foundation
extension BootomSheetChartVC{
    //一小时
    func OneHourTimeInterval(date0:Date){
        var  date = date0
        TimeDateInterval = [String]()
        for i in 0..<60 {
            if i % 5 == 0 {
                TimeInterval_oneHour.append("\(date.toFormat("HH:mm"))")
            }else{
                TimeInterval_oneHour.append("")
            }
            TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
            date = date + 1.minutes
        }
        TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
        TimeInterval_oneHour.append("\(date.toFormat("HH:mm"))")
    }
    //六小时
    func SixHoursTimeInterval(date0:Date){
        var  date = date0
        TimeDateInterval = [String]()
        for i in 0..<360 {
            if i % 30 == 0 {
                TimeInterval_sixHours.append("\(date.toFormat("HH:mm"))")
            }else{
                TimeInterval_sixHours.append("")
            }
            TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
            date = date + 1.minutes
        }
        TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
        TimeInterval_sixHours.append("\(date.toFormat("HH:mm"))")
    }
    //十二小时
    func TwelveHoursTimeInterval(date0:Date){
        var  date = date0
        TimeDateInterval = [String]()
        for i in 0..<720 {
            if i % 60 == 0 {
                TimeInterval_twelveHours.append("\(date.toFormat("HH:mm"))")
            }else{
                TimeInterval_twelveHours.append("")
            }
            TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
            date = date + 1.minutes
        }
        TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
        TimeInterval_twelveHours.append("\(date.toFormat("HH:mm"))")
    }
    //本日
    func DayTimeInterval(){
        var date = Date()
        date = date.dateAt(.startOfDay)
        TimeDateInterval = [String]()
        for i in 0..<1440 {
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
            TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
            date = date + 1.minutes
        }
        TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
        TimeInterval_day.append("24:00")
    }
    //一周
    func SevenDayTimeInterval(date2:Date){
        let  date = date2
        var start = date.dateAt(.startOfDay) - 6.days
        let Interval = [6,6,5,5,4,4,3,3,2,2,1,1,0,0]
        TimeDateInterval = [String]()
        var j = 0
        for i in 0..<2016 {
            if i%144 == 0 {
                let timeKind = ((i / 144 % 2) == 0) ? "00:00" : "12:00"
                let date0  = date - Interval[j].days
                let str = date0.toFormat("MM-dd")
                TimeInterval_Sevenday.append("\(str) \(timeKind)")
                j = j+1
            }else{
                TimeInterval_Sevenday.append("")
            }
            TimeDateInterval.append("\(start.toFormat("yyyy-MM-dd HH:mm"))")
            start = start + 5.minutes
        }
        let date1 = date + 1.days
        TimeDateInterval.append("\(start.toFormat("yyyy-MM-dd HH:mm"))")
        TimeInterval_Sevenday.append("\(date1.toFormat("MM-dd")) 00:00")
    }
    //一月
    func MonthTimeInterval(date2:Date){
        let  date = date2
        var start = date2 - 30.days
        start = start.dateAt(.startOfDay)
        TimeDateInterval = [String]()
        var j = 30
        for i in 0..<1488 {
            if i%48 == 0 {

                let date0  = date - j.days
                let str = date0.toFormat("MM-dd")
                TimeInterval_Month.append("\(str)")
                print(i,j)
                j = j-1
            }else{
                TimeInterval_Month.append("")
            }
            TimeDateInterval.append("\(start.toFormat("yyyy-MM-dd HH:mm"))")
            start = start + 30.minutes
        }
        let date1 = date + 1.days
        TimeDateInterval.append("\(start.toFormat("yyyy-MM-dd HH:mm"))")
        TimeInterval_Month.append("\(date1.toFormat("MM-dd"))")
        print(TimeInterval_Month)
    }
    //一年
    func YearTimeInterval(date2:Date){
        let  date = date2 
        let date1 = date - 1.years + 1.months
        var start = date1.dateAtStartOf(.month)
        TimeDateInterval = [String]()
        for _ in 0..<365 {
            
//            if start.date == start.dateAtStartOf(.month){
//                let str = start.toFormat("yyyy-MM-dd")
//                TimeInterval_Year.append("\(str)")
//            }else{
//                TimeInterval_Year.append("")
//            }
            let str = start.toFormat("yyyy-MM-dd")
            TimeInterval_Year.append("\(str)")
            TimeDateInterval.append("\(start.toFormat("yyyy-MM-dd HH:mm"))")
            start = start + 1.days
        }
        TimeDateInterval.append("\(start.toFormat("yyyy-MM-dd HH:mm"))")
        TimeInterval_Year.append("\(start.toFormat("yyyy-MM-dd"))")
    }
}
