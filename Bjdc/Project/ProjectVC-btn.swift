//
//  ProjectVC-btn.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/4.
//

import Foundation

extension ProjectVC{
    
    func initButtonView(){
        let zoomPannelView = self.makeZoomPannelView()
        zoomPannelView.center = CGPoint.init(x: self.view.bounds.size.width -  zoomPannelView.bounds.width/2 - 10, y: self.view.bounds.size.height -  zoomPannelView.bounds.width/2 - 300)
        zoomPannelView.backgroundColor = .white
        zoomPannelView.contentMode = .scaleAspectFill
        zoomPannelView.autoresizingMask = [UIView.AutoresizingMask.flexibleTopMargin , UIView.AutoresizingMask.flexibleLeftMargin]
        self.view.addSubview(zoomPannelView)
        
        viewButton = self.makeviewButtonView()
        viewButton.setTitleColor(.black, for: .normal)
        viewButton.center = CGPoint.init(x: self.view.bounds.size.width -  zoomPannelView.bounds.width/2 - 10, y: self.view.bounds.size.height -  viewButton.bounds.width/2 - 400)
        self.view.addSubview(viewButton)
        viewButton.autoresizingMask = [UIView.AutoresizingMask.flexibleTopMargin , UIView.AutoresizingMask.flexibleRightMargin]
    }
    //放大缩小样式
    func makeZoomPannelView() -> UIView {
        let ret = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 88))
        
        let incBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        incBtn.setImage(UIImage.init(systemName: "plus"), for: .normal)
        incBtn.backgroundColor = .white
        incBtn.tintColor = .black
        incBtn.imageView?.scalesLargeContentImage = true
        incBtn.addTarget(self, action: #selector(self.zoomPlusAction), for: UIControl.Event.touchUpInside)
    
        
        let decBtn = UIButton.init(frame: CGRect.init(x: 0, y: 44, width: 44, height: 44))
        decBtn.setImage(UIImage.init(systemName: "minus"), for: .normal)
        decBtn.backgroundColor = .white
        decBtn.tintColor = .black
        decBtn.imageView?.scalesLargeContentImage = true
        decBtn.addTarget(self, action: #selector(self.zoomMinusAction), for: UIControl.Event.touchUpInside)
        
        
        ret.addSubview(incBtn)
        ret.addSubview(decBtn)
        
        return ret
    }
    func makeviewButtonView() -> UIButton! {
        let ret = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 48, height: 48))
        ret.backgroundColor = UIColor.white
        ret.layer.cornerRadius = 4
        ret.setTitle("标准", for: .normal)
        ret.addTarget(self, action: #selector(self.gpsAction), for: UIControl.Event.touchUpInside)
        
        return ret
    }
    //初始化地图页面
    func initMapView() {
      mapView = MAMapView(frame: self.view.bounds)
        mapView.showsCompass = false
        mapView.delegate = self
        self.view.addSubview(mapView)
    }
    
    //MARK:- event handling
    @objc func zoomPlusAction() {
        let oldZoom = self.mapView.zoomLevel
        self.mapView.setZoomLevel(oldZoom+1, animated: true)
    }
    
    @objc func zoomMinusAction() {
        let oldZoom = self.mapView.zoomLevel
        self.mapView.setZoomLevel(oldZoom-1, animated: true)
    }
    @objc func gpsAction() {
        flage = !flage
        if flage {
            mapView.mapType = .satellite
            viewButton.setTitle("卫星", for: .normal)
        }else{
            mapView.mapType = .standard
            viewButton.setTitle("标准", for: .normal)
        }
        
    }
}
