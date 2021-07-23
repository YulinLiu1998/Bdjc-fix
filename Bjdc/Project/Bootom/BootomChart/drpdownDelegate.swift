//
//  drpdownDelegate.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/8.
//
import SwiftDate
import SwiftyJSON
import Foundation
import Malert
import PGDatePicker
extension BootomSheetChartVC:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
    func numberOfOptions(in menu: LMJDropdownMenu) -> UInt {
        var count:UInt?
        if menu == dateDropdown {
            count =  UInt(dateDropdownTitles!.count)
        }else if menu == nameDropdown {
            count = UInt(nameDropdownTitles!.count)
        }
        return count!
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, heightForOptionAt index: UInt) -> CGFloat {
        return 30
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, titleForOptionAt index: UInt) -> String {
        var titles:String?
        if menu == dateDropdown {
            titles =  dateDropdownTitles![Int(index)]
        }else if menu == nameDropdown {
            titles = nameDropdownTitles![Int(index)]
        }
        return titles!
    }
    
    //MARK: -LMJDropdownMenuDelegate
    func dropdownMenu(_ menu: LMJDropdownMenu, didSelectOptionAt index: UInt, optionTitle title: String) {
        if menu == dateDropdown{
            print("dateDropdown")
            print("您选择了index：\(index),title: \(title)")
            
            if index == 0 {
                //最近一小时
                lastOneHour()
                
            }else if index == 1 {
                //最近6小时
                lastSixHours()
            }else if index == 2 {
                //最近12小时
                lastTwelveHours()
               
            }else if index == 3 {
                //本日
                Nowdays()
               
            }else if index == 4 {
                //本周
                lastWeek()
              
            }else if index == 5 {
                //一月
                lastmonth()
                
            }else if index == 6 {
                //一年
                lastYear()
            }else{
                //自定义
                customSetting()
                
                
                
                
                
            }
        }else if menu == nameDropdown{
            print("nameDropdown")
            print("您选择了index：\(index),title: \(title)")
            StationUUID = ProjectList![CurrentProject!]["StationList"][Int(index)]["StationUUID"].stringValue
            if CurrentTimeInterval == 0 {
                //最近一小时
                lastOneHour()
            }else if CurrentTimeInterval == 1 {
                //最近6小时
                lastSixHours()
            }else if CurrentTimeInterval == 2 {
                //最近12小时
                lastTwelveHours()
            }else if CurrentTimeInterval == 3 {
                //本日
                Nowdays()
            }else if CurrentTimeInterval == 4 {
                //本周
                lastWeek()
            }else if CurrentTimeInterval == 5 {
                //一月
                lastmonth()
            }else if CurrentTimeInterval == 6 {
                //一年
                lastYear()
            }else{
                //自定义
                customSetting()
            }
        }
        
        
        
    }
}

extension BootomSheetChartVC{
    func lastOneHour(){
        var  date = Date()
        date = Date.dateFromGMT(date)
        if date.minute % 5 != 0{
            date = date + (5 - ( date.minute % 5)).minutes
        }
        EndTime = date.toFormat("yyyy-MM-dd HH:mm:ss")
        //EndTime = "2021-03-09 \(date.toFormat("HH:mm:ss"))"
        date = date - 1.hours
        
        StartTime = date.toFormat("yyyy-MM-dd HH:mm:ss")
        //StartTime = "2021-03-09 \(date.toFormat("HH:mm:ss"))"
        CurrentTimeInterval = 0
        TimeInterval_oneHour = [String]()
        OneHourTimeInterval(date0: date)
        TimeIntervalKind[CurrentTimeInterval!] = TimeInterval_oneHour
        getFilterGraphicData()
    }
    func lastSixHours(){
        var  date = Date()
        date = Date.dateFromGMT(date)
        if date.minute % 30 != 0{
            date = date + (30 - ( date.minute % 30)).minutes
        }
        EndTime = date.toFormat("yyyy-MM-dd HH:mm:ss")
       
        //EndTime = "2021-03-09 \(date.toFormat("HH:mm:ss"))"
        date = date - 6.hours
        StartTime = date.toFormat("yyyy-MM-dd HH:mm:ss")
        //StartTime = "2021-03-09 \(date.toFormat("HH:mm:ss"))"
        CurrentTimeInterval = 1
        TimeInterval_sixHours = [String]()
        SixHoursTimeInterval(date0: date)
        TimeIntervalKind[CurrentTimeInterval!] = TimeInterval_sixHours
        getFilterGraphicData()
    }
    func lastTwelveHours(){
        var  date = Date()
        date = Date.dateFromGMT(date)
        if date.minute % 60 != 0{
            date = date + (60 - ( date.minute % 60)).minutes
        }
        EndTime = date.toFormat("yyyy-MM-dd HH:mm:ss")
        date = date - 12.hours
       
        StartTime = date.toFormat("yyyy-MM-dd HH:mm:ss")
        CurrentTimeInterval = 2
        
        TimeInterval_twelveHours = [String]()
        TwelveHoursTimeInterval(date0: date)
        TimeIntervalKind[CurrentTimeInterval!] = TimeInterval_twelveHours
        getFilterGraphicData()
    }
    func Nowdays(){
        var  date = Date()
        date = Date.dateFromGMT(date)
        StartTime = date.toFormat("yyyy-MM-dd 00:00:00")
        //EndTime = "2021-03-09 23:59:59"
        EndTime = date.toFormat("yyyy-MM-dd 23:59:59")
        //StartTime = "2021-03-09 00:00:00"
        CurrentTimeInterval = 3
        TimeInterval_day = [String]()
        DayTimeInterval()
        TimeIntervalKind[CurrentTimeInterval!] = TimeInterval_day
        getFilterGraphicData()
    }
    func lastWeek(){
        var  date = Date()
        date = Date.dateFromGMT(date)
       
        let date0  = date - 6.days
        let str = date0.toFormat("yyyy-MM-dd")
        StartTime = "\(str) 00:00:00"
        //StartTime = "2021-03-03 00:00:00"
        let date1  = date + 1.days
        let str1 = date1.toFormat("yyyy-MM-dd")
        EndTime = "\(str1) 00:00:00"
        //EndTime = "2021-03-10 00:00:00"
        
        CurrentTimeInterval = 4
        TimeInterval_Sevenday = [String]()
        SevenDayTimeInterval(date2: date)
        
        TimeIntervalKind[CurrentTimeInterval!] = TimeInterval_Sevenday
        getFilterGraphicData()
    }
    func lastmonth(){
        var  date = Date()
        date = Date.dateFromGMT(date)
        let date0  = date - 30.days
        let str = date0.toFormat("yyyy-MM-dd")
        StartTime = "\(str) 00:00:00"
        let date1  = date + 1.days
        let str1 = date1.toFormat("yyyy-MM-dd")
        EndTime = "\(str1) 00:00:00"
        CurrentTimeInterval = 5
        TimeInterval_Month = [String]()
        MonthTimeInterval(date2: date)
        TimeIntervalKind[CurrentTimeInterval!] = TimeInterval_Month
        getFilterGraphicData()
    }
    func lastYear(){
        var  date = Date()
        date = Date.dateFromGMT(date)
        var date1 = date - 1.years + 1.months
        let start = date1.dateAtStartOf(.month)
        var str = start.toFormat("yyyy-MM-dd")
        StartTime = "\(str) 00:00:00"
        //StartTime = "2020-04-04 00:00:00"
        date1 = date + 1.months
        let end = date1.dateAtStartOf(.month)
        str = end.toFormat("yyyy-MM-dd")
        EndTime = "\(str) 00:00:00"
        //EndTime = "2021-03-10 00:00:00"
        CurrentTimeInterval = 6
        TimeInterval_Year = [String]()
        YearTimeInterval(date2: date)
        TimeIntervalKind[CurrentTimeInterval!] = TimeInterval_Year
        getFilterGraphicData()
    }
    func customSetting(){
        //自定义查询时间界面
        let AlertView = AlertView.instantiateFromNib()
        //CustomAlert = customAlert
        alertView = AlertView
        let alert = Malert(title: "自定义查询时间", customView: alertView)
        alert.textAlign = .center
        alert.textColor = .gray
        alert.titleFont = UIFont.systemFont(ofSize: 20)
        alert.margin = 16//左右边距
        alert.buttonsAxis = .horizontal
        alert.separetorColor = .clear
        //取消按钮
        let registerAction = MalertAction(title: "取消", backgroundColor: UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)){
            print("取消")
        }
        registerAction.tintColor = .gray
        alert.addAction(registerAction)
        //确定按钮
        let loginAction = MalertAction(title: "查询", backgroundColor: UIColor(red:0.10, green:0.14, blue:0.49, alpha:1.0)){ [self] in
            print("确定")
        
            StartTime = CustomStartTime
            EndTime = CustomEndTime
            let start = StartTime!.toDate()
            print("日期：", start!.date)
            let end = EndTime!.toDate()
            print("日期：", end!.date)
            let diffDateComponents = Calendar.current.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day,Calendar.Component.hour], from: dateStartComponents!, to: dateEndComponents!)
            DiffDateComponents = diffDateComponents
            guard start!.date < end!.date else {
                DispatchQueue.main.async{
                    self.view.showError("您输入的日期时间有误！")
                }
                return
            }
            guard diffDateComponents.year!  <= 2  else {
                
                DispatchQueue.main.async{
                    self.view.showError("日期区间需在两年以内！")
                }
                return
            }
           
            CurrentTimeInterval = 7
            if diffDateComponents.year! > 1 || (diffDateComponents.year! == 1 && ( diffDateComponents.month! > 0 || diffDateComponents.day! > 0 || diffDateComponents.hour! > 0) ){
                //大于1年小于等于2年
                print("大于1年小于等于2年")
                CustomStatus = "moreOneYear"
                moreOneYear(start: start!, end: end!)
            }else if diffDateComponents.month! > 6 || diffDateComponents.year! == 1 {
                //大于6个月小于等于1年
                print("大于6个月小于等于1年")
                CustomStatus = "moreSixMonths"
                moreSixMonths(start: start!, end: end!)
            }else if diffDateComponents.month! > 1 || (diffDateComponents.month! == 1 && (diffDateComponents.hour! > 0 || diffDateComponents.day! > 0 ) ){
                //大于1个月小于等于6个月
                print("大于1个月小于等于6个月")
                CustomStatus = "moreOneMonth"
               moreOneMonth(start: start!, end: end!)
            }else if diffDateComponents.day! > 7 || diffDateComponents.month! == 1{
                //大于7小于等于1个月
                print("大于7小于等于1个月")
                CustomStatus = "moreSevenDays"
               moreSevenDays(start: start!, end: end!)
            }else if diffDateComponents.day! > 3 || (diffDateComponents.day! == 3 && diffDateComponents.hour! > 0 ){
                //大于3天小于等于7天
                print("大于3天小于等于7天")
                CustomStatus = "moreThreeDays"
                moreThreeDays(start: start!, end: end!)
            }else if diffDateComponents.day! > 1 || (diffDateComponents.day! == 1 && diffDateComponents.hour! > 0 ){
                //大于1天小于等于3天
                print("大于1天小于等于3天")
                CustomStatus = "moreOneDays"
                moreOneDays(start: start!, end: end!)
            }else if diffDateComponents.hour! > 12 || diffDateComponents.day! == 1{
                //大于12小于等于24小时
                print("大于12小于等于24小时")
                CustomStatus = "moreTweleveHours"
                moreTweleveHours(start: start!, end: end!)
            }else{
                //小于等于12个小时
                print("小于等于12个小时")
                CustomStatus = "lessEqualTweleveHours"
                lessEqualTweleveHours(start: start!, end: end!)
            }
        }
        loginAction.tintColor = .white
        alert.addAction(loginAction)
        present(alert, animated: true)
        
    }
}
extension BootomSheetChartVC{
    func moreOneYear(start:DateInRegion,end:DateInRegion){
        //大于1年小于等于2年 24小时一条数据

        print("大于1年小于等于2年")
        var date = start
        var endDate = end
        if date.day != 1 {
                date = date.dateAt(.startOfMonth)
        }
        if endDate.day != 1 {
                endDate = endDate.dateAt(.startOfMonth) + 1.months
        }

        var time = date - endDate
        time = time / 60
        let points = Int(time / 60 / 24)
       
        TimeDateInterval = [String]()
        TimeInterval_Custom = [String]()
        for _ in 0..<points {
           
            if date.day == 1 {
                TimeInterval_Custom.append("\(date.toFormat("yyyy-MM-dd"))")
            }else{
                TimeInterval_Custom.append("\(date.toFormat("yyyy-MM-dd"))")
            }
           
            TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd"))")
            date = date + 1.days
        }
        TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd"))")
        TimeInterval_Custom.append("\(date.toFormat("yyyy-MM-dd"))")
        TimeIntervalKind[7] = TimeInterval_Custom
        VisibleXRangeMaximum[7] = points / 2
        DeltaTime[7] = "86400"
        AxisMaximum[7] = points + points / 10
        AxisGranularity[7] = 12
        print("points",points)

        getFilterGraphicData()
    }
    func moreSixMonths(start:DateInRegion,end:DateInRegion){
        //大于6个月小于等于1年 两个小时读取一个点
        print("大于6个月小于等于1年")
        var date = start
        var endDate = end
        if date.day != 1 {
                date = date.dateAt(.startOfMonth)
        }
        if endDate.day != 1 {
                endDate = endDate.dateAt(.startOfMonth) + 1.months
        }

        var time = date - endDate
        time = time / 60
        let points = Int(time / 120)
       
        TimeDateInterval = [String]()
        TimeInterval_Custom = [String]()
        for i in 0..<points {
            if i % 12 == 0 {
                if date.day == 1 {
                    TimeInterval_Custom.append("\(date.toFormat("yyyy-MM-dd"))")
                }else{
                    TimeInterval_Custom.append("\(date.toFormat("yyyy-MM-dd"))")
                }
            }else{
                TimeInterval_Custom.append("")
            }
            TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd"))")
            date = date + 2.hours
        }
        TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd"))")
        TimeInterval_Custom.append("\(date.toFormat("yyyy-MM-dd"))")
        TimeIntervalKind[7] = TimeInterval_Custom
        VisibleXRangeMaximum[7] = points / 2
        DeltaTime[7] = "7200"
        AxisMaximum[7] = points + 10
        AxisGranularity[7] = 12
        print(VisibleXRangeMaximum[7])
        print(DeltaTime[7])
        print(AxisMaximum[7])
        print(AxisGranularity[7])
        print("poins",points)
        getFilterGraphicData()
    }
    func moreOneMonth(start:DateInRegion,end:DateInRegion){
        //大于1个月小于等于6个月 两个小时读取一个点
       
        print("大于1个月小于等于6个月")
        var date = start
        let endDate = end
        var time = date - endDate
        time = time / 60
        let points = Int(time / 180)
        TimeInterval_Custom = [String]()
        TimeDateInterval = [String]()
        for i in 0..<points {
            if i % 12 == 0 {//date.dateAt(.startOfMonth)
                if date.day == 1 {
                    TimeInterval_Custom.append("\(date.toFormat("yyyy-MM-dd"))")
                }else if date.day == 15 {
                    TimeInterval_Custom.append("\(date.toFormat("yyyy-MM-dd"))")
                }else{
                    TimeInterval_Custom.append("\(date.toFormat("yyyy-MM-dd"))")
                }
            }else{
                TimeInterval_Custom.append("")
            }
            TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd"))")
            date = date + 3.hours
        }
        TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd"))")
        TimeInterval_Custom.append("\(date.toFormat("yyyy-MM-dd"))")
        TimeIntervalKind[7] = TimeInterval_Custom
        VisibleXRangeMaximum[7] = points / 2
        DeltaTime[7] = "10800"
        AxisMaximum[7] = points + points / 10
        AxisGranularity[7] = 12
        print(VisibleXRangeMaximum[7])
        print(DeltaTime[7])
        print(AxisMaximum[7])
        print(AxisGranularity[7])
        print("poins",points)
        getFilterGraphicData()
    }
    func moreSevenDays(start:DateInRegion,end:DateInRegion){
        //大于7小于等于1个月 轴标签间隔 24时   30分钟读取一个点
       
        print("大于7小于等于1个月")
        var date = start
        let monthOfDays = date.monthDays
        var points = (DiffDateComponents?.month)! * monthOfDays * 60 * 24 + (DiffDateComponents?.day)! * 60 * 24 + (DiffDateComponents?.hour)! * 60
        points = points / 30
        TimeInterval_Custom = [String]()
        TimeDateInterval = [String]()
        for i in 0..<points {
            if i % 48 == 0 {
                TimeInterval_Custom.append("\(date.toFormat("MM-dd HH"))")
            }else{
                TimeInterval_Custom.append("")
            }
            TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH"))")
            date = date + 30.minutes
        }
        print("points",points)
        TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
        TimeInterval_Custom.append("\(date.toFormat("MM-dd HH"))")
        TimeIntervalKind[7] = TimeInterval_Custom
        if points > 1200 {
            VisibleXRangeMaximum[7] = 624
        }else{
            VisibleXRangeMaximum[7] = points / 2 //300
        }
       
        DeltaTime[7] = "1800"
        AxisMaximum[7] = points + points / 10
        AxisGranularity[7] = 48
        print(VisibleXRangeMaximum[7])
        print(DeltaTime[7])
        print(AxisMaximum[7])
        print(AxisGranularity[7])
        print("poins",points)
        getFilterGraphicData()
    }
    func moreThreeDays(start:DateInRegion,end:DateInRegion){
        //大于3天小于等于7天 5分钟一条数据 轴标签间隔 12时
        print("大于3天小于等于7天")
        
        var date = start
        var hour = (DiffDateComponents?.hour)!
        let day = (DiffDateComponents?.day)!
        hour = day * 24 + hour
        if ((hour  % 12) != 0) {
            hour = hour + (12 - (hour  % 12))
        }
        var points = hour * 60
        points = points / 5
        TimeInterval_Custom = [String]()
        TimeDateInterval = [String]()
        for i in 0..<points {
            if i % 144 == 0 {
                TimeInterval_Custom.append("\(date.toFormat("MM-dd HH"))")
            }else{
                TimeInterval_Custom.append("")
            }
            TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
            date = date + 5.minutes
        }
        TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
        TimeInterval_Custom.append("\(date.toFormat("MM-dd HH"))")
        TimeIntervalKind[7] = TimeInterval_Custom
        VisibleXRangeMaximum[7] = points / 2 + points / 10
        DeltaTime[7] = "300"
        AxisMaximum[7] = points + points / 10
        AxisGranularity[7] = 144
        print( VisibleXRangeMaximum[7])
        print(DeltaTime[7])
        print( AxisMaximum[7] )
        print(AxisGranularity[7])
        print("poins",points)
        getFilterGraphicData()
    }
    func moreOneDays(start:DateInRegion,end:DateInRegion){
        //大于1天小于等于3天 10分钟一条数据 轴标签间隔 6时
        print("大于1天小于等于3天")
        var date = start
        var hour = (DiffDateComponents?.hour)!
        let day = (DiffDateComponents?.day)!
        hour = day * 24 + hour
        if ((hour  % 6) != 0) {
            hour = hour + ( 6 - (hour  % 6))
        }
        var points = hour * 60
        points = points / 10
        TimeInterval_Custom = [String]()
        TimeDateInterval = [String]()
        for i in 0..<points {
            if i % 18 == 0 {
                TimeInterval_Custom.append("\(date.toFormat("MM-dd HH"))")
            }else{
                TimeInterval_Custom.append("")
            }
            TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
            date = date + 10.minutes
        }
        TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
        TimeInterval_Custom.append("\(date.toFormat("MM-dd HH"))")
        TimeIntervalKind[7] = TimeInterval_Custom
        VisibleXRangeMaximum[7] = points / 2 + points / 10
        DeltaTime[7] = "600"
        AxisMaximum[7] = points + points / 10
        AxisGranularity[7] = 36
        print(VisibleXRangeMaximum[7])
        print(DeltaTime[7])
        print(AxisMaximum[7])
        print(AxisGranularity[7])
        print("poins",points)
        getFilterGraphicData()
        //大于1天小于等于3天 5分钟一条数据 轴标签间隔 6时
//        print("大于1天小于等于3天")
//        var date = start
//        var hour = (DiffDateComponents?.hour)!
//        let day = (DiffDateComponents?.day)!
//        hour = day * 24 + hour
//        if ((hour  % 6) != 0) {
//            hour = hour + ( 6 - (hour  % 6))
//        }
//        var points = hour * 60
//        points = points / 5
//        TimeInterval_Custom = [String]()
//        TimeDateInterval = [String]()
//        for i in 0..<points {
//            if i % 36 == 0 {
//                TimeInterval_Custom.append("\(date.toFormat("MM-dd HH"))")
//            }else{
//                TimeInterval_Custom.append("")
//            }
//            TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
//            date = date + 5.minutes
//        }
//        TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
//        TimeInterval_Custom.append("\(date.toFormat("MM-dd HH"))")
//        TimeIntervalKind[7] = TimeInterval_Custom
//        VisibleXRangeMaximum[7] = points / 2 + points / 10
//        DeltaTime[7] = "300"
//        AxisMaximum[7] = points + points / 10
//        AxisGranularity[7] = 36
//        print(VisibleXRangeMaximum[7])
//        print(DeltaTime[7])
//        print(AxisMaximum[7])
//        print(AxisGranularity[7])
//        print("poins",points)
//        getFilterGraphicData()
    }
    func moreTweleveHours(start:DateInRegion,end:DateInRegion){
        //大于12小于等于24小时 一分钟请求一条数据 轴标签间隔 2时
        print("大于12小于等于24小时")
        var hour = (DiffDateComponents?.hour)!
        if ((hour  % 2) != 0) {
            hour = hour + 1
        }
        var date = start
        let points = (DiffDateComponents?.day)! * 60 * 24 + hour * 60
        TimeDateInterval = [String]()
        TimeInterval_Custom = [String]()
        for i in 0..<points {
            if i % 120 == 0 {
                TimeInterval_Custom.append("\(date.toFormat("MM-dd HH"))")
            }else{
                TimeInterval_Custom.append("")
            }
            TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
            date = date + 1.minutes
        }
        TimeInterval_Custom.append("\(date.toFormat("MM-dd HH"))")
        TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
        TimeIntervalKind[7] = TimeInterval_Custom
        VisibleXRangeMaximum[7] = 750
        DeltaTime[7] = "60"
        AxisMaximum[7] = points + points / 10
        AxisGranularity[7] = 120
        print( VisibleXRangeMaximum[7])
        print(DeltaTime[7])
        print( AxisMaximum[7] )
        print(AxisGranularity[7])
        print("poins",points)
        getFilterGraphicData()
    }
    func lessEqualTweleveHours(start:DateInRegion,end:DateInRegion){
        //小于等于12个小时 2分钟请求一条数据 轴标签间隔1时
        print("小于等于12个小时")
       var date = start
        let points = (DiffDateComponents?.hour)! * 60 / 2
        TimeDateInterval = [String]()
        TimeInterval_Custom = [String]()
        for i in 0..<points {
            if i % 30 == 0 {
                TimeInterval_Custom.append("\(date.toFormat("MM-dd HH"))")
            }else{
                TimeInterval_Custom.append("")
            }
            //记录每一个间隔点的表示的时间数据
            TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
            date = date + 2.minutes
        }
        TimeInterval_Custom.append("\(date.toFormat("MM-dd HH"))")
        TimeDateInterval.append("\(date.toFormat("yyyy-MM-dd HH:mm"))")
        
        TimeIntervalKind[7] = TimeInterval_Custom
        VisibleXRangeMaximum[7] = points / 2 + points / 10
        DeltaTime[7] = "120"
        AxisMaximum[7] = points + points / 10
        AxisGranularity[7] = 30
        print( VisibleXRangeMaximum[7])
        print(DeltaTime[7])
        print( AxisMaximum[7] )
        print(AxisGranularity[7])
        print("poins",points)
        getFilterGraphicData()
    }
}
