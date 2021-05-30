//
//  ProjectVC.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import UIKit

class ProjectVC: UIViewController, MAMapViewDelegate {

    //定义地图页面
    var mapView: MAMapView!
    //定义标记数组
    var annotations: Array<MAPointAnnotation>!
    
    @IBOutlet weak var ContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.view.backgroundColor = UIColor.gray
        //初始化地图页面
        initMapView()
        //初始化地图标记
        initAnnotations()  
        BootomSheetVC.openDemo(from: self, in: self.view)
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
    
    
    //初始化地图页面
    func initMapView() {
//        mapView = MAMapView(frame: self.view.bounds)
        mapView = MAMapView(frame: ContainerView.bounds)
        mapView.showsCompass = false
        mapView.delegate = self
        self.view.addSubview(mapView)
    }
    
    
    //初始化地图标记
    func initAnnotations() {
        annotations = Array()
        
        //定义标记位置
        let coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 39.992520, longitude: 116.336170),
            CLLocationCoordinate2D(latitude: 39.978234, longitude: 116.352343),
            CLLocationCoordinate2D(latitude: 39.998293, longitude: 116.348904),
            CLLocationCoordinate2D(latitude: 40.004087, longitude: 116.353915),
            CLLocationCoordinate2D(latitude: 40.001442, longitude: 116.353915),
            CLLocationCoordinate2D(latitude: 39.989105, longitude: 116.360200),
            CLLocationCoordinate2D(latitude: 39.989098, longitude: 116.360201),
            CLLocationCoordinate2D(latitude: 39.998439, longitude: 116.324219),
            CLLocationCoordinate2D(latitude: 39.979590, longitude: 116.352792)]
        //遍历数组将位置信息加入标记数组
        for (idx, coor) in coordinates.enumerated() {
            let anno = MAPointAnnotation()
            anno.coordinate = coor
            anno.title = String(idx)
        
            annotations.append(anno)
        }

    }
    
    //MARK: - MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            annotationView!.isDraggable = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
            
            let idx = annotations.firstIndex(of: annotation as! MAPointAnnotation)
            print("\(idx)")
            annotationView!.pinColor = MAPinAnnotationColor(rawValue: idx! % 3)!
            
            return annotationView!
        }
        
        return nil
    }


}
