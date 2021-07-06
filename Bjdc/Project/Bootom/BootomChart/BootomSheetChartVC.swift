//
//  BootomSheetChartVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/26.
//

import UIKit
import SwiftyJSON
import Charts
class BootomSheetChartVC: UIViewController {
    

    //var stationUUID:String?
    var test:String?

    var TimeInterval_week = [String]()
    var TimeInterval_month = [String]()
    var TimeInterval_year = [String]()
    var TimeInterval_Moreyears = [String]()

    var nameDropdownTitles:Array<String>?
    var nameDropdown:LMJDropdownMenu?
    var dateDropdownTitles:Array<String>?
    var dateDropdown:LMJDropdownMenu?
    @IBOutlet var RootView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chartTitle: UILabel!
    @IBOutlet weak var exportBtn: UIButton!
    //下拉框view
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var HeaderView: UIView!
    
    var content:JSON?
    @IBOutlet weak var GNSSFilterInfoNCell: UIView!
    @IBOutlet weak var NStart: UILabel!
    @IBOutlet weak var Nend: UILabel!
    @IBOutlet weak var NStackView: UIStackView!
    @IBOutlet weak var Ntips: UILabel!
    
    
    @IBOutlet weak var GNSSFilterInfoECell: UIView!
    @IBOutlet weak var EStart: UILabel!
    @IBOutlet weak var Eend: UILabel!
    @IBOutlet weak var EStackView: UIStackView!
    @IBOutlet weak var Etips: UILabel!
    
    @IBOutlet weak var GNSSFilterInfoHCell: UIView!
    @IBOutlet weak var Hstatr: UILabel!
    @IBOutlet weak var Hend: UILabel!
    @IBOutlet weak var HStackView: UIStackView!
    @IBOutlet weak var Htips: UILabel!
    
    
    
    @IBOutlet weak var GNSSFilterInfoDeltaD: UIView!
    @IBOutlet weak var DeltaDstatr: UILabel!
    @IBOutlet weak var DeltaDend: UILabel!
    @IBOutlet weak var Delta: UIStackView!
    @IBOutlet weak var DeltaTips: UILabel!
    
    @IBOutlet weak var GNSSFilterInfoDeltaHCell:
        UIView!
    @IBOutlet weak var DeltaHstatr: UILabel!
    @IBOutlet weak var DeltaHend: UILabel!
    @IBOutlet weak var DetalHStackView: UIStackView!
    @IBOutlet weak var DetalHtips: UILabel!
    
    @IBOutlet weak var HeartCell: UIView!
    @IBOutlet weak var HeartStart: UILabel!
    @IBOutlet weak var HeartEnd: UILabel!
    @IBOutlet weak var HeartStackView: UIStackView!
    @IBOutlet weak var HeartTips: UILabel!
    
    var chartView1: LineChartView!
    var chartView2: LineChartView!
    var chartView3: LineChartView!
    var chartView4: LineChartView!
    var chartView5: LineChartView!
    var chartView6: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        //初始化站点名称下拉菜单
        dropdownName()
        //初始化日期选择下拉菜单
        dropdownDate()
        //设置标题
        chartTitle.text = currentDrodownTitle
        //初始化图表
        initViewCharts()
        //显示图表
        showCharts()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func backEvent(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func exportFile(_ sender: Any) {
        getStationReport()
    }
    
    func initViewCharts(){
        chartView1 = LineChartView()
        chartView1.frame = CGRect(x: 20, y:80 , width: self.view.bounds.width  , height: 500)
        self.GNSSFilterInfoNCell.addSubview(chartView1)
        
        chartView2 = LineChartView()
        chartView2.frame = CGRect(x: 20, y:80 , width: self.view.bounds.width , height: 500)
        self.GNSSFilterInfoECell.addSubview(chartView2)
        
        chartView3 = LineChartView()
        chartView3.frame = CGRect(x: 20, y:80 , width: self.view.bounds.width , height: 500)
        self.GNSSFilterInfoHCell.addSubview(chartView3)
        
        chartView4 = LineChartView()
        chartView4.frame = CGRect(x: 20, y:80 , width: self.view.bounds.width, height: 500)
        self.GNSSFilterInfoDeltaD.addSubview(chartView4)
        
        chartView5 = LineChartView()
        chartView5.frame = CGRect(x: 20, y:80 , width: self.view.bounds.width, height: 500)
        self.GNSSFilterInfoDeltaHCell.addSubview(chartView5)
        
        chartView6 = LineChartView()
        chartView6.frame = CGRect(x: 20, y:80 , width: self.view.bounds.width, height: 500)
        self.HeartCell.addSubview(chartView6)
        
        chartView1.noDataText = "暂无数据"
        chartView1.noDataTextColor = .systemGray
        chartView2.noDataText = "暂无数据"
        chartView2.noDataTextColor = .systemGray
        chartView3.noDataText = "暂无数据"
        chartView3.noDataTextColor = .systemGray
        chartView4.noDataText = "暂无数据"
        chartView4.noDataTextColor = .systemGray
        chartView5.noDataText = "暂无数据"
        chartView5.noDataTextColor = .systemGray
        chartView6.noDataText = "暂无数据"
        chartView6.noDataTextColor = .systemGray
        
    }
    func showCharts(){
        guard ChartData!["Content"].count != 0 else{
            
            NStackView.isHidden = true
            Ntips.isHidden = false
            EStackView.isHidden = true
            Etips.isHidden = false
            HStackView.isHidden = true
            Htips.isHidden = false
            Delta.isHidden = true
            DeltaTips.isHidden = false
            DetalHStackView.isHidden = true
            DetalHtips.isHidden = false
            HeartStackView.isHidden = true
            HeartTips.isHidden = false
            return
        }
        
        content = ChartData!["Content"]
        //GNSSFilterInfoNCell
        print("GNSSFilterInfoNCell")
        GNSSFilterInfoN()
        NStart.text = StartTime
        Nend.text = EndTime
        //GNSSFilterInfoECell
        print("GNSSFilterInfoECell")
        GNSSFilterInfoE()
        EStart.text = StartTime
        Eend.text = EndTime
        //GNSSFilterInfoHCell
        print("GNSSFilterInfoHCell")
        GNSSFilterInfoH()
        Hstatr.text = StartTime
        Hend.text = EndTime
        //GNSSFilterInfoDeltaDCell
        print("GNSSFilterInfoDeltaDCell")
        GNSSFilterInfoDeltaDD()
        DeltaDstatr.text = StartTime
        DeltaDend.text = EndTime
        //GNSSFilterInfoDeltaHCell
        print("GNSSFilterInfoDeltaHCell")
        GNSSFilterInfoDeltaH()
        DeltaHstatr.text = StartTime
        DeltaHend.text = EndTime
        //Heart
        Heart()
        HeartStart.text = StartTime
        HeartEnd.text = EndTime
    }
    
    @objc private func slide(pan: UIPanGestureRecognizer){
        let translationY = pan.translation(in: scrollView).y
        if pan.velocity(in: scrollView).y / scrollView.bounds.height > 0.5{
            print("translationY",translationY)
        }

    }
}
