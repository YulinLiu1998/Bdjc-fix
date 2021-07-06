//
//  GNSSFilterInfoH.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/9.
//


import Foundation
import Charts
import SwiftyJSON
extension BootomSheetChartVC{
    func GNSSFilterInfoH(){
        
        //GNSSFilterInfoNCell
        //折线图
        //创建折线图组件对象
       
         
        //设置 x 轴位置
        chartView3.xAxis.labelPosition = .bottom //x轴显示在下方
        chartView3.xAxis.axisMinimum = 0 //最小刻度值
        chartView3.xAxis.axisMaximum = 1500 //最大刻度值
        chartView3.xAxis.granularity = 120 //最小间隔´
        chartView3.xAxis.labelCount = 14
        chartView3.xAxis.labelFont = .systemFont(ofSize: 12) //刻度文字大小
        chartView3.xAxis.labelRotationAngle = -30 //刻度文字倾斜角度
        //自定义刻度标签文字 0 60 120
        
        let xValues = TimeIntervalKind[CurrentTimeInterval!]

        chartView3.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        //设置 y 轴位置
        chartView3.rightAxis.enabled = false //禁用右侧的Y轴
        chartView3.leftAxis.labelFont = .systemFont(ofSize: 12)
        chartView3.leftAxis.granularity = 0.01 //最小间隔
        
        var min = ChartData!["Min"][4].stringValue
        min = min.subStringFrom(startIndex: 1)
        chartView3.leftAxis.axisMinimum = Double(min)! - 0.1//最小刻度值
        var max = ChartData!["Max"][4].stringValue
        max = max.subStringFrom(startIndex: 1)
        chartView3.leftAxis.axisMaximum =  Double(max)! + 0.1//最大刻度值
        //折线图背景色
        chartView3.backgroundColor = UIColor.white
                 
        //折线图无数据时显示的提示文字
        chartView3.noDataText = "暂无数据"
                 
     
                 
        //设置交互样式
        chartView3.scaleYEnabled = true //取消Y轴缩放
        chartView3.doubleTapToZoomEnabled = true //双击缩放
        chartView3.dragEnabled = true //启用拖动手势
        chartView3.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        chartView3.dragDecelerationFrictionCoef = 0.5//拖拽后惯性效果摩擦系数(0~1)越小惯性越不明显
        
    
        
        
        //生成1440条随机数据
       
        var dataEntries = [ChartDataEntry]()
        var j = 0
        for i in 0..<(xValues.count - 1) {
            //本日
            if j < content!.count{
                if TimeDateInterval[i] == content![j][0].stringValue.getString(startIndex: 0, endIndex: 15) {
                    let y = Double(content![j][4].stringValue)
                    let entry = ChartDataEntry.init(x: Double(i), y: y!)
                    dataEntries.append(entry)
                    j = j + 1
                }
            }
        }
        //数据作为1根折线里的所有数据
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        chartView3.legend.form = .none
        //将线条颜色设置为橙色 下面将折线改成橙色（其对应的图例颜色也会自动改变）
        chartDataSet.colors = [.link]
        //修改线条大小
        chartDataSet.lineWidth = 2
        chartDataSet.drawCirclesEnabled = false //不绘制转折点
        chartDataSet.mode = .horizontalBezier  //贝塞尔曲线
        chartDataSet.drawValuesEnabled = false //不绘制拐点上的文字
        chartDataSet.highlightEnabled = false  //不启用十字线
        //目前折线图只包括1根折线
        let chartData = LineChartData(dataSets: [chartDataSet])
 
        //设置折现图数据
        chartView3.data = chartData
        
        //设置缩放
        chartView3.setScaleMinima(1, scaleY: 3)
        //图表最多显示点书
        chartView3.setVisibleXRangeMaximum(Double(VisibleXRangeMaximum[CurrentTimeInterval!]))
        //默认显示最一个数据
        chartView3.moveViewToY(Double(ChartData!["Average"][4].stringValue)!, axis: .left
        )
    }
    
    func updateH(){
       
        
        chartView3.isHidden = false
        //设置 x 轴位置
        chartView3.xAxis.labelPosition = .bottom //x轴显示在下方
        chartView3.xAxis.axisMinimum = 0 //最小刻度值
        chartView3.xAxis.axisMaximum = Double(AxisMaximum[CurrentTimeInterval!]) //最大刻度值
        chartView3.xAxis.granularity = Double(AxisGranularity[CurrentTimeInterval!]) //最小间隔
        chartView3.xAxis.labelCount = 14
        chartView3.xAxis.labelFont = .systemFont(ofSize: 12) //刻度文字大小
        chartView3.xAxis.labelRotationAngle = -30 //刻度文字倾斜角度
        
        
        //自定义刻度标签文字
        let xValues = TimeIntervalKind[CurrentTimeInterval!]
        chartView3.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        //设置 y 轴位置 setGranularityEnabled
        chartView3.rightAxis.enabled = false //禁用右侧的Y轴
        chartView3.leftAxis.labelFont = .systemFont(ofSize: 12)
        
        chartView3.leftAxis.granularity = 0.01 //最小间隔
        
        var min = ChartData!["Min"][4].stringValue
        min = min.subStringFrom(startIndex: 1)
        chartView3.leftAxis.axisMinimum = Double(min)! - 0.05//最小刻度值
        print("min",min)
        print("最小刻度值",Double(min)! - 0.05)
        var max = ChartData!["Max"][4].stringValue
        max = max.subStringFrom(startIndex: 1)
        chartView3.leftAxis.axisMaximum =  Double(max)! + 0.05//最大刻度值
        let length_Y = Double(max)! + 0.05 - Double(min)! + 0.05
        print("刻度差值：",length_Y )
     
        //设置交互样式
        chartView3.scaleYEnabled = true //取消Y轴缩放
        chartView3.doubleTapToZoomEnabled = true //双击缩放
        chartView3.dragEnabled = true //启用拖动手势
        chartView3.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        chartView3.dragDecelerationFrictionCoef = 0.5//拖拽后惯性效果摩擦系数(0~1)越小惯性越不明显
        chartView3.zoomToCenter(scaleX: 0, scaleY: 0)
        
        
        
        var dataEntries = [ChartDataEntry]()
        var j = 0
        for i in 0..<(xValues.count - 1) {
            if CurrentTimeInterval == 7{
                //自定义
                if  CustomStatus == "lessEqualTweleveHours" || CustomStatus == "moreTweleveHours"{
                    if j < content!.count{
                        if TimeDateInterval[i] == content![j][0].stringValue.subStringTo(endIndex: 15) {
                            let y = Double(content![j][4].stringValue)
                            let entry = ChartDataEntry.init(x: Double(i), y: y!)
                            dataEntries.append(entry)
                            j = j + 1
                        }
                    }
                }else if CustomStatus == "moreOneDays" || CustomStatus == "moreThreeDays"{
                    if j < content!.count{
                        if TimeDateInterval[i].subStringTo(endIndex: 14) == content![j][0].stringValue.subStringTo(endIndex: 14) {
                            let y = Double(content![j][4].stringValue)
                            let entry = ChartDataEntry.init(x: Double(i), y: y!)
                            dataEntries.append(entry)
                            j = j + 1
                        }
                    }
                }else if CustomStatus == "moreSevenDays"{
                    if j < content!.count{
                        if TimeDateInterval[i] == content![j][0].stringValue.subStringTo(endIndex: 12) {
                            let y = Double(content![j][4].stringValue)
                            let entry = ChartDataEntry.init(x: Double(i), y: y!)
                            dataEntries.append(entry)
                            j = j + 1
                        }
                    }
                }else {
                    if j < content!.count{
                        if TimeDateInterval[i] == content![j][0].stringValue.subStringTo(endIndex: 9) {
                            let y = Double(content![j][4].stringValue)
                            let entry = ChartDataEntry.init(x: Double(i), y: y!)
                            dataEntries.append(entry)
                            j = j + 1
                        }
                    }
                }
                
            }else if CurrentTimeInterval == 6{
                //一年
                if j < content!.count{
                    if TimeDateInterval[i].subStringTo(endIndex: 9) == content![j][0].stringValue.subStringTo(endIndex: 9) {
                      
                        let y = Double(content![j][4].stringValue)
                        let entry = ChartDataEntry.init(x: Double(i), y: y!)
                        dataEntries.append(entry)
                        j = j + 1
                    }
                }
                
            }else if CurrentTimeInterval == 5{
                //一月  显示精度为60分钟
                if j < content!.count{
                    if TimeDateInterval[i].getString(startIndex: 0, endIndex: 12) == content![j][0].stringValue.getString(startIndex: 0, endIndex: 12) {
                       
                        let y = Double(content![j][4].stringValue)
                        let entry = ChartDataEntry.init(x: Double(i), y: y!)
                        dataEntries.append(entry)
                        j = j + 1
                    }
                }
            }else if CurrentTimeInterval == 4{
                //一周  显示精度为10分钟
                if j < content!.count{
                    if TimeDateInterval[i].getString(startIndex: 5, endIndex: 14) == content![j][0].stringValue.getString(startIndex: 5, endIndex: 14) {
                       
                        let y = Double(content![j][4].stringValue)
                        let entry = ChartDataEntry.init(x: Double(i), y: y!)
                        dataEntries.append(entry)
                        j = j + 1
                    }
                }
                
            }else if CurrentTimeInterval == 3{
                //本日  显示精度为1分钟
                if j < content!.count{
                    if TimeDateInterval[i] == content![j][0].stringValue.getString(startIndex: 0, endIndex: 15) {
                        let y = Double(content![j][4].stringValue)
                        let entry = ChartDataEntry.init(x: Double(i), y: y!)
                        dataEntries.append(entry)
                        j = j + 1
                    }
                }
                
            }else if CurrentTimeInterval == 2{
                //十二小时  显示精度为一分钟
                if j < content!.count{
                    
                    if TimeDateInterval[i] == content![j][0].stringValue.getString(startIndex: 0, endIndex: 15) {
                        let y = Double(content![j][4].stringValue)
                        let entry = ChartDataEntry.init(x: Double(i), y: y!)
                        dataEntries.append(entry)
                        j = j + 1
                    }
                }
            }else if CurrentTimeInterval == 1{
                //六小时  显示精度为一分钟
                if j < content!.count{
                    if TimeDateInterval[i] == content![j][0].stringValue.getString(startIndex: 0, endIndex: 15) {
                        let y = Double(content![j][4].stringValue)
                        let entry = ChartDataEntry.init(x: Double(i), y: y!)
                        dataEntries.append(entry)
                        j = j + 1
                    }
                }
            }else if CurrentTimeInterval == 0{
                //一小时 显示精度为一分钟
                if j < content!.count{
                    if TimeDateInterval[i] == content![j][0].stringValue.getString(startIndex: 0, endIndex: 15) {
                        let y = Double(content![j][4].stringValue)
                        let entry = ChartDataEntry.init(x: Double(i), y: y!)
                        dataEntries.append(entry)
                        j = j + 1
                    }
                }
                
            }

        }
        //数据作为1根折线里的所有数据
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        
       
        
        chartView3.legend.form = .none
        //线条颜色
        chartDataSet.colors = [.link]
        //修改线条大小
        chartDataSet.lineWidth = 2
        chartDataSet.drawCirclesEnabled = false //不绘制转折点
        chartDataSet.mode = .linear
        chartDataSet.drawValuesEnabled = false //不绘制拐点上的文字
        chartDataSet.highlightEnabled = false  //不启用十字线
        //目前折线图只包括1根折线
        let chartData = LineChartData(dataSets: [chartDataSet])
        //设置折现图数据
       
        chartView3.data = chartData
        //设置缩放
        if length_Y > 0.14 {
            chartView3.setScaleMinima(1, scaleY: 1.6)
        }else{
            chartView3.setScaleMinima(1, scaleY: 1.5)
        }
        
        //图表最多显示点书
        chartView3.setVisibleXRangeMaximum(Double(VisibleXRangeMaximum[CurrentTimeInterval!]))
        //默认显示最一个数据
        chartView3.moveViewToY(Double(ChartData!["Average"][4].stringValue)!, axis: .left)
        chartView3.scaleYEnabled = false //取消Y轴缩放
    }
}
