//
//  AnnotationView.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/6.
//

import Foundation

class CustomAnnotationViewSwift: MAAnnotationView {
    //定义气泡背景与内容对象
    var calloutView : CustomCalloutViewSwift?
    
    var content : String?
    
    //重写选中效果
    override func setSelected(_ selected: Bool, animated: Bool) {
        if self.isSelected == selected{
            return;
        }
        if selected {
            if calloutView == nil {
                calloutView = CustomCalloutViewSwift.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
                calloutView!.center = CGPoint.init(x: bounds.width/2 + calloutOffset.x, y: -calloutView!.bounds.height/2 + calloutOffset.y)
            }
            
            calloutView!.titleLabel.text = annotation.title as? NSString as String?
            calloutView!.subtitleLabel.text = annotation.subtitle as? NSString as String?
            addSubview(calloutView!)
        } else {
            calloutView!.removeFromSuperview()
        }
        super.setSelected(selected, animated: animated)
    }
    
    func setContent(content : String){
        self.content = content
    }
}
