//
//  TestViewController.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/9.
//
import PGDatePicker
import UIKit
import Charts
import Malert
import SwiftDate
class TestViewController: UIViewController {

    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var View2: UIView!
    @IBOutlet weak var Time: UIButton!
    var chartView1: LineChartView!
    var chartView2: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建折线图组件对象
        print("初始化")
        chart1()
  
      }
    @IBAction func ChangeColor(_ sender: Any) {
        print("更新")
        updateChart1()
      
    }
    @IBAction func SetTime(_ sender: Any) {
   
        let customAlert = customAlert.instantiateFromNib()
        CustomAlert = customAlert
        let alert = Malert(title: "自定义查询时间", customView: customAlert)
        alert.textAlign = .center
        alert.textColor = .gray
        alert.titleFont = UIFont.systemFont(ofSize: 20)
        alert.margin = 16//左右边距
        alert.buttonsAxis = .horizontal
        alert.separetorColor = .clear
        
        
        let registerAction = MalertAction(title: "取消", backgroundColor: UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0))
        registerAction.tintColor = .gray
        alert.addAction(registerAction)
        
        let loginAction = MalertAction(title: "查询", backgroundColor: UIColor(red:0.10, green:0.14, blue:0.49, alpha:1.0)){
            StartTime = CustomStartTime
            EndTime = CustomEndTime
            let start = StartTime!.toDate()
            print("日期：", start!.date)
            let end = EndTime!.toDate()
            print("日期：", end!.date)


            

        }
        loginAction.tintColor = .white
        alert.addAction(loginAction)
        present(alert, animated: true)
    }
    func chart1() {
        chartView1 = LineChartView()
        chartView1.frame = CGRect(x: 20, y: 80, width: self.view.bounds.width - 40,
                                        height: 300)
        //折线图无数据时显示的提示文字
        chartView1.noDataText = "暂无数据"
        chartView1.noDataFont = UIFont.systemFont(ofSize: 50)
        self.View1.addSubview(chartView1)
        var chartsDataArray = [ChartDataEntry]()
        chartsDataArray.append(ChartDataEntry(x: 0, y: 0))
           chartsDataArray.append(ChartDataEntry(x: 2, y: 2))
           chartsDataArray.append(ChartDataEntry(x: 4, y: 4))
           chartsDataArray.append(ChartDataEntry(x: 2, y: 6))
           chartsDataArray.append(ChartDataEntry(x: 0, y: 8))
        chartsDataArray.append(ChartDataEntry(x: 4, y: 2))
        chartsDataArray.append(ChartDataEntry(x: 2, y: 6))
        chartsDataArray.append(ChartDataEntry(x: 0, y: 9))
        chartsDataArray.append(ChartDataEntry(x: 4, y: 1))
        chartsDataArray.append(ChartDataEntry(x: 2, y: 0))
        chartsDataArray.append(ChartDataEntry(x: 0, y: 3))
        let chartDataSet = LineChartDataSet(entries: chartsDataArray, label: "图例1")
               //修改线条大小
               chartDataSet.lineWidth = 2
               //目前折线图只包括1根折线
               let chartData = LineChartData(dataSets: [chartDataSet])
               //设置折现图数据
        chartView1.xAxis.labelRotationAngle = 90 //刻度文字倾斜角度
        chartView1.data = chartData
    }
    func chart2() {
       
    }
    func   updateChart1(){
        
        //生成10条随机数据
        var dataEntries = [ChartDataEntry]()
        for _ in 0..<10 {
            let y = arc4random()%100
            let x = arc4random()%100
            let entry = ChartDataEntry.init(x: Double(x), y: Double(y))
            dataEntries.append(entry)
        }
        //这10条数据作为1根折线里的所有数据
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "图例1")


        //修改线条大小
        chartDataSet.lineWidth = 2
        //目前折线图只包括1根折线
        let chartData = LineChartData(dataSets: [chartDataSet])
        //设置折现图数据
        chartView1.data = chartData
    }
    func   updateChart2(){
       
    }
}


