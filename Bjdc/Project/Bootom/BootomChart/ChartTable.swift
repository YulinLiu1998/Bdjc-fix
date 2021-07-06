//
//  ChartTableVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/10.
//

import UIKit
import SwiftyJSON
class ChartTable: UITableViewController {
    //UITableViewController
    var UpdateChartTable:(()->())?
    var LabelsssText:String?
    @IBOutlet weak var Labelsss: UILabel!
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
    
    @IBOutlet weak var HeartCell: UITableViewCell!
    @IBOutlet weak var HeartStart: UILabel!
    @IBOutlet weak var HeartEnd: UILabel!
    @IBOutlet weak var HeartStackView: UIStackView!
    @IBOutlet weak var HeartTips: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Labelsss.text = LabelsssText
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
        
//        content = ChartData!["Content"]
//        //GNSSFilterInfoNCell
//        print("GNSSFilterInfoNCell")
//        GNSSFilterInfoN()
//        NStart.text = StartTime
//        Nend.text = EndTime
//        //GNSSFilterInfoECell
//        print("GNSSFilterInfoECell")
//        GNSSFilterInfoE()
//        EStart.text = StartTime
//        Eend.text = EndTime
//        //GNSSFilterInfoHCell
//        print("GNSSFilterInfoHCell")
//        GNSSFilterInfoH()
//        Hstatr.text = StartTime
//        Hend.text = EndTime
//        //GNSSFilterInfoDeltaDCell
//        print("GNSSFilterInfoDeltaDCell")
//        GNSSFilterInfoDeltaDD()
//        DeltaDstatr.text = StartTime
//        DeltaDend.text = EndTime
//        //GNSSFilterInfoDeltaHCell
//        print("GNSSFilterInfoDeltaHCell")
//        GNSSFilterInfoDeltaH()
//        DeltaHstatr.text = StartTime
//        DeltaHend.text = EndTime
//        //Heart
//        Heart()
//        HeartStart.text = StartTime
//        HeartEnd.text = EndTime
    }
    func updateCharts() {
        Labelsss.text = "一小时"
//        DispatchQueue.main.async { [self] in
//            guard ChartData!["Content"].count != 0 else{
//                NStackView.isHidden = true
//                Ntips.isHidden = false
//                EStackView.isHidden = true
//                Etips.isHidden = false
//                HStackView.isHidden = true
//                Htips.isHidden = false
//                Delta.isHidden = true
//                DeltaTips.isHidden = false
//                DetalHStackView.isHidden = true
//                DetalHtips.isHidden = false
//                HeartStackView.isHidden = true
//                HeartTips.isHidden = false
//                return
//            }

//            content = ChartData!["Content"]
//            //GNSSFilterInfoNCell
//            print("GNSSFilterInfoNCell")
//            GNSSFilterInfoN()
//            NStart.text = StartTime
//            Nend.text = EndTime
//            //GNSSFilterInfoECell
//            print("GNSSFilterInfoECell")
//            GNSSFilterInfoE()
//            EStart.text = StartTime
//            Eend.text = EndTime
//            //GNSSFilterInfoHCell
//            print("GNSSFilterInfoHCell")
//            GNSSFilterInfoH()
//            Hstatr.text = StartTime
//            Hend.text = EndTime
//            //GNSSFilterInfoDeltaDCell
//            print("GNSSFilterInfoDeltaDCell")
//            GNSSFilterInfoDeltaDD()
//            DeltaDstatr.text = StartTime
//            DeltaDend.text = EndTime
//            //GNSSFilterInfoDeltaHCell
//            print("GNSSFilterInfoDeltaHCell")
//            GNSSFilterInfoDeltaH()
//            DeltaHstatr.text = StartTime
//            DeltaHend.text = EndTime
//            //Heart
//            Heart()
//            HeartStart.text = StartTime
//            HeartEnd.text = EndTime
//        }
        
    }
    
}
