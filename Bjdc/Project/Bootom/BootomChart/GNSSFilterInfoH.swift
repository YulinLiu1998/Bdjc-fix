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
        var chartView: LineChartView!
        //创建折线图组件对象
        chartView = LineChartView()
        chartView.frame = CGRect(x: 20, y:80 , width: self.view.bounds.width + 100 , height: 500)
        self.GNSSFilterInfoHCell.addSubview(chartView)
         
        //设置 x 轴位置
        chartView.xAxis.labelPosition = .bottom //x轴显示在下方
        chartView.xAxis.axisMinimum = 0 //最小刻度值
        chartView.xAxis.axisMaximum = 1500 //最大刻度值
        chartView.xAxis.granularity = 120 //最小间隔´
        chartView.xAxis.labelCount = 14
        chartView.xAxis.labelFont = .systemFont(ofSize: 12) //刻度文字大小
        chartView.xAxis.labelRotationAngle = -30 //刻度文字倾斜角度
        //自定义刻度标签文字 0 60 120
        
        let xValues = TimeInterval_day

        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        //设置 y 轴位置
        chartView.rightAxis.enabled = false //禁用右侧的Y轴
        chartView.leftAxis.labelFont = .systemFont(ofSize: 12)
        
        //折线图背景色
        chartView.backgroundColor = UIColor.white
                 
        //折线图无数据时显示的提示文字
        chartView.noDataText = "暂无数据"
                 
     
                 
        //设置交互样式
        chartView.scaleYEnabled = false //取消Y轴缩放
        chartView.doubleTapToZoomEnabled = true //双击缩放
        chartView.dragEnabled = true //启用拖动手势
        chartView.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        chartView.dragDecelerationFrictionCoef = 0.5//拖拽后惯性效果摩擦系数(0~1)越小惯性越不明显
        
    
        
        
        //生成1440条随机数据
       
        var dataEntries = [ChartDataEntry]()
        for i in 0..<ChartData!["Content"].count {
            //let y = arc4random()%100
            let str = ChartData!["Content"][i][4].stringValue
            let subStr = str.getString(startIndex: 1, count: str.count-3)
            let y = Double(subStr)
            let entry = ChartDataEntry.init(x: Double(i), y: y!)
            //let entry = ChartDataEntry.init(x: Double(i), y: Double(y)!)
            
            dataEntries.append(entry)
            
        }
        //数据作为1根折线里的所有数据
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        chartView.legend.form = .none
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
        chartView.data = chartData
    }
}
