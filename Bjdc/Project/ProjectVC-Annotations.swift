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
        guard StationLongitudes[CurrentProject!].count != 0 || StationLatitudes[CurrentProject!].count != 0  else {
            self.view.showInfolong("当前工程检测点无位置信息，无法显示标记！")
            print("当前工程检测点无位置信息，无法显示标记！")
            return
        }
        updateMap()
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
            
            let kind = customPointAnnotationViewSwift.kindOfStatus
            annotationView!.image = UIImage(named: kind)
            let  reSize =  CGSize (width: 44, height: 44)
            annotationView!.image = annotationView!.image?.reSizeImage(reSize: reSize)
            
            return annotationView!
        }
        
        return nil
    }

}
