//
//  Heart.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/9.
//

import Foundation
import Charts
import SwiftyJSON
extension BootomSheetChartVC{
    func Heart() {
   
        
        //折线图
        //创建折线图组件对象
        chartView6.isHidden = false
        //设置 x 轴位置
        chartView6.xAxis.labelPosition = .bottom //x轴显示在下方
        chartView6.xAxis.granularity = 0.01 //最小间隔
        chartView6.xAxis.labelFont = .systemFont(ofSize: 12) //刻度文字大小
        chartView6.xAxis.labelRotationAngle = -30 //刻度文字倾斜角度
        var min = Double(ChartData!["Min"][3].stringValue)!
        chartView6.xAxis.axisMinimum = min - 0.01 //最小刻度值
        var max = Double(ChartData!["Max"][3].stringValue)!
        chartView6.xAxis.axisMaximum = max + 0.01 //最大刻度值

       
 
        //设置 y 轴位置
        chartView6.rightAxis.enabled = false //禁用右侧的Y轴
        chartView6.leftAxis.labelFont = .systemFont(ofSize: 12)
        chartView6.leftAxis.granularity = 0.01 //最小间隔
        
        min = Double(ChartData!["Min"][2].stringValue)!
        chartView6.leftAxis.axisMinimum = min - 0.01//最小刻度值
        max = Double(ChartData!["Max"][2].stringValue)!
        chartView6.leftAxis.axisMaximum =  max + 0.01//最大刻度值
        //设置Y轴距离
//        let length_Y = (max + 0.1 - min + 0.1)
//        let portion_Y = (length_Y / 0.01)
//        let Num_Y = portion_Y * 62.5
//        let Scale_Y = Num_Y / Double(chartView1.bounds.height)
//        chartView6.setScaleMinima(1, scaleY: CGFloat(Scale_Y))
        //折线图背景色
        chartView6.backgroundColor = UIColor.white
        
        chartView6.rightAxis.enabled = false //禁用右侧的Y轴
        chartView6.leftAxis.labelFont = .systemFont(ofSize: 12)
        chartView6.leftAxis.granularity = 0.01 //最小间隔
        
        
        //设置交互样式
        chartView6.scaleYEnabled = false //取消Y轴缩放
        chartView6.scaleXEnabled = false //取消X轴缩放
        chartView6.doubleTapToZoomEnabled = false //双击缩放
        chartView6.dragEnabled = false //启用拖动手势
        chartView6.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        chartView6.dragDecelerationFrictionCoef = 0.5//拖拽后惯性效果摩擦系数(0~1)越小惯性越不明显
        
        
        
        //生成1440条随机数据
        
        var dataEntries = [ChartDataEntry]()
        for i in 0..<content!.count {
            let str = content![i][2].stringValue
            let y = Double(str)
            let str1 = content![i][3].stringValue
            let x = Double(str1)
            let entry = ChartDataEntry.init(x: x!, y: y!)
            dataEntries.append(entry)
        }
        
        //数据作为1根折线里的所有数据
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        chartView6.legend.form = .none
        //将线条颜色设置为橙色 下面将折线改成橙色（其对应的图例颜色也会自动改变）
        chartDataSet.colors = [.link]
        //修改线条大小
        chartDataSet.lineWidth = 2
        chartDataSet.drawCirclesEnabled = false //不绘制转折点
        chartDataSet.mode = .linear  //贝塞尔曲线
        chartDataSet.drawValuesEnabled = false //不绘制拐点上的文字
        chartDataSet.highlightEnabled = false  //不启用十字线
        //目前折线图只包括1根折线
        let chartData = LineChartData(dataSets: [chartDataSet])
        
        
        //设置折现图数据
        HeartChart = true
        chartView6.data = chartData

    }
}
//LineChartRenderer 214- 216
//if cur == nil {
//    return
//}


//BarLineScatterCandleBubbleChartRenderer111
//fileprivate init(min: Int, max: Int) {
//    if min < max{
//        self.iterator = (min...max).makeIterator()
//    }else{
//        self.iterator = (max...min).makeIterator()
//    }
//   
//}


//76BarLineScatterCandleBubbleRenderer.swift
//let phaseX = Swift.max(0.0, Swift.min(1.0, animator?.phaseX ?? 1.0))
//
////            let low = chart.lowestVisibleX
////            let high = chart.highestVisibleX
////
////            let entryFrom = dataSet.entryForXValue(low, closestToY: .nan, rounding: .down)
////            let entryTo = dataSet.entryForXValue(high, closestToY: .nan, rounding: .up)
////
////            self.min = entryFrom == nil ? 0 : dataSet.entryIndex(entry: entryFrom!)
////            self.max = entryTo == nil ? 0 : dataSet.entryIndex(entry: entryTo!)
////range = Int(Double(self.max - self.min) * phaseX)
//self.min = 0
//self.max = Int(chart.highestVisibleX)
//range = Int(Double(self.max - self.min) * phaseX)

//{
//    let phaseX = Swift.max(0.0, Swift.min(1.0, animator?.phaseX ?? 1.0))
//
////            let low = chart.lowestVisibleX
////            let high = chart.highestVisibleX
////
////            let entryFrom = dataSet.entryForXValue(low, closestToY: .nan, rounding: .down)
////            let entryTo = dataSet.entryForXValue(high, closestToY: .nan, rounding: .up)
////
////            self.min = entryFrom == nil ? 0 : dataSet.entryIndex(entry: entryFrom!)
////            self.max = entryTo == nil ? 0 : dataSet.entryIndex(entry: entryTo!)
//    //range = Int(Double(self.max - self.min) * phaseX)
//    self.min = 0
//    self.max = Int(chart.highestVisibleX)
//    range = Int(Double(self.max - self.min) * phaseX)
//
//}
//}
