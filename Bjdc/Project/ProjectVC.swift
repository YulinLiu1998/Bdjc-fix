//
//  ProjectVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import UIKit
import Malert
class ProjectVC: UIViewController,UpdateMapView {
 
    

    //定义地图页面
    var mapView: MAMapView!
    var viewButton: UIButton!
    var flage = false
    var mapflage = false
    
//    //定义标记数组
//    var annotations: Array<MAPointAnnotation>!
    var annotationsUpadate: Array<MAPointAnnotation>!
    
    @IBOutlet weak var ContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //初始化地图页面
        initMapView()
        mapView = MapView
        //初始化地图标记
        initAnnotations()
        //zoomPannelView
        initButtonView()
        //let bootom = (storyboard?.instantiateViewController(identifier: "BootomSheet")) as! BootomSheetVC
       //bootom.delegate = self
        BootomSheetVC.openDemo(from: self, in: self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }
    func updateMap() {
        
        annotations = Array()
        
        var coordinates = [CLLocationCoordinate2D]()
        var stationKinds = [String]()
        for i in 0 ..< StationLongitudes[CurrentProject!].count{
            let Longitudes = CLLocationDegrees(StationLongitudes[CurrentProject!][i])
            let Latitudes  = CLLocationDegrees(StationLatitudes[CurrentProject!][i])
            if Latitudes != nil && Longitudes != nil {
                let amapcoord = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: Latitudes!, longitude: Longitudes!),.GPS)
                coordinates.append(amapcoord)
                let status = Int(stationStatus[CurrentProject!][i])
                if status! >= 10 && status! < 19{
                    stationKinds.append("online")
                }else if status! >= 20 && status! < 29{
                    stationKinds.append("offline")
                }else if status! >= 30 && status! < 39{
                    stationKinds.append("warning")
                }else{
                    stationKinds.append("error")
                }
            }
            
            
        }
        
        //遍历数组将位置信息加入标记数组
        for (idx, coor) in coordinates.enumerated() {
            //let anno = MAPointAnnotation()
            let anno = CustomPointAnnotationViewSwift()
            //经纬度
            anno.coordinate = coor
            //标题
            anno.title = "监测点名称：\(stationNames[CurrentProject!][idx])"
            let type = stationTypes[CurrentProject!][idx] == "1" ? "基准站":"移动站"
            anno.subtitle = "监测点类型：\(type)"
            anno.kindOfStatus = stationKinds[idx]
            //添加标记
            annotations.append(anno)
        }
        

        MapView.addAnnotations(annotations)
        MapView.showAnnotations(annotations, animated: true)
        MapView.setZoomLevel(17, animated: true)
        MapView.setCenter(annotations[0].coordinate, animated: true)
        //选中标注数据对应的view
        MapView.selectAnnotation(annotations.first, animated: true)
    }
    func updateMapView() {
       
        DispatchQueue.main.async{ [self] in
          
            MapView.removeAnnotations(annotations)
            self.updateMap()
        }
    }
    func removeAnnotationsMapView() {
       
        DispatchQueue.main.async{
            MapView.removeAnnotations(annotations)
        }
    }

}
