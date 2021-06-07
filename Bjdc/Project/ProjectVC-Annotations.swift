//
//  ProjectVC-Annotations.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/4.
//

import Foundation
extension ProjectVC:MAMapViewDelegate{
    //初始化地图标记
    func initAnnotations() {
        
        annotations = Array()
        
        //定义标记位置
        
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
                print("online")
                stationKinds.append("online")
            }else if status! >= 20 && status! < 29{
                print("offline")
                stationKinds.append("offline")
            }else if status! >= 30 && status! < 39{
                print("warning")
                stationKinds.append("warning")
            }else{
                print("error")
                stationKinds.append("error")
            }
            print("stationKinds",stationKinds)
            
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

    }
    
    
    
    //MARK: - MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let customPointAnnotationViewSwift = annotation as!CustomPointAnnotationViewSwift
            let customReuseIndetifier: String = "customReuseIndetifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: customReuseIndetifier) as? CustomAnnotationViewSwift
            
            if annotationView == nil {
                annotationView = CustomAnnotationViewSwift.init(annotation: annotation, reuseIdentifier: customReuseIndetifier)
                //是否允许弹出callout
                annotationView?.canShowCallout = false
                ///添加到地图时是否使用下落动画效果
                // annotationView!.animatesDrop = false
                ///是否支持拖动
                annotationView?.isDraggable = true
                ///弹出框默认位于view正中上方，可以设置calloutOffset改变view的位置，正的偏移使view朝右下方移动，负的朝左上方，单位是屏幕坐标
                annotationView?.calloutOffset = CGPoint.init(x: 0, y: -5)
            }
            
            print(customPointAnnotationViewSwift.kindOfStatus)
            let kind = customPointAnnotationViewSwift.kindOfStatus
            annotationView!.image = UIImage(named: kind)
            let  reSize =  CGSize (width: 44, height: 44)
            annotationView!.image = annotationView!.image?.reSizeImage(reSize: reSize)
            
            return annotationView!
        }
        
        return nil
    }

}
