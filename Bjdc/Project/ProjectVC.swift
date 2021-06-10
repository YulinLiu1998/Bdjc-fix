//
//  ProjectVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import UIKit

class ProjectVC: UIViewController,UpdateMapView {
 
    

    //定义地图页面
    var mapView: MAMapView!
    var viewButton: UIButton!
    var flage = false
    var mapflage = false
    
    //定义标记数组
    var annotations: Array<MAPointAnnotation>!
    var annotationsUpadate: Array<MAPointAnnotation>!
    
    @IBOutlet weak var ContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化地图页面
        initMapView()
        //初始化地图标记
        initAnnotations()
        //zoomPannelView
        initButtonView()
        //let bootom = (storyboard?.instantiateViewController(identifier: "BootomSheet")) as! BootomSheetVC
       //bootom.delegate = self
        BootomSheetVC.openDemo(from: self, in: self.view)
        MapView = mapView
       
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //向地图窗口添加一组标注
        mapView.addAnnotations(annotations)
        //设置地图使其可以显示数组中所有的annotation, 如果数组中只有一个则直接设置地图中心为annotation的位置
        mapView.showAnnotations(annotations, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
        //选中标注数据对应的view
        mapView.selectAnnotation(annotations.first, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }
    func updateMap() {
        MapView.removeAnnotations(annotations)
        annotations = Array()
        let coordinates1: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 39.992520, longitude: 116.336170),
            CLLocationCoordinate2D(latitude: 39.978234, longitude: 116.352343),
            CLLocationCoordinate2D(latitude: 39.998293, longitude: 116.348904),
            CLLocationCoordinate2D(latitude: 40.004087, longitude: 116.353915),
            CLLocationCoordinate2D(latitude: 40.001442, longitude: 116.353915),
            CLLocationCoordinate2D(latitude: 39.989105, longitude: 116.360200),
            CLLocationCoordinate2D(latitude: 39.989098, longitude: 116.360201),
            CLLocationCoordinate2D(latitude: 39.998439, longitude: 116.324219),
            CLLocationCoordinate2D(latitude: 39.979590, longitude: 116.352792)]
        var coordinates = [CLLocationCoordinate2D]()
        var stationKinds = [String]()
        for i in 0 ..< StationLongitudes[CurrentProject!].count{
            let Longitudes = CLLocationDegrees(StationLongitudes[CurrentProject!][i])
            let Latitudes  = CLLocationDegrees(StationLatitudes[CurrentProject!][i])
            if Latitudes == nil || Longitudes == nil {
                coordinates.append(coordinates1[i])
            }else{
                coordinates.append(CLLocationCoordinate2D(latitude: Latitudes!, longitude: Longitudes!))
            }
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
        MapView.showAnnotations(annotations, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
        //选中标注数据对应的view
        MapView.selectAnnotation(annotations.first, animated: true)
    }
    func updateMapView(city:String) {
        print(city)
        DispatchQueue.main.async{
            self.updateMap()
        }
        
    }
    

}
