//
//  BootomSheetDropdownMenu.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import Foundation

extension BootomSheetVC{

    
    func dropdownMenuBootomSheet() {
        _menu1OptionTitles = ["Option1","Option2","Option3","Option4","Option5"]
        _menu1OptionIcons = ["icon1","icon2","icon3","icon4","icon5"]
        
        
        
        navMenu1 = LMJDropdownMenu.init()
        NavMenu1 = navMenu1
        let frame =  CGRect(x: 40, y: 2, width: self.view.bounds.size.width-80, height: 40)
        navMenu1?.frame = frame
        navMenu1?.dataSource = self
        navMenu1?.delegate   = self
        
        navMenu1?.layer.borderUIColor = .black
        navMenu1?.layer.borderWidth  = 0
        navMenu1?.layer.cornerRadius = 0
        
        navMenu1?.title = "Option1"
        currentTitle = navMenu1?.title
        navMenu1?.titleBgColor = .white
        navMenu1?.titleFont = .boldSystemFont(ofSize: 15)
        navMenu1?.titleColor = .label
        navMenu1?.titleAlignment = .center
        navMenu1?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        navMenu1?.rotateIcon = UIImage(systemName: "arrowtriangle.down.fill")!
        navMenu1?.rotateIconSize = CGSize(width: 15, height: 15);
        navMenu1?.rotateIconMarginRight = 15;
        
        navMenu1?.optionBgColor = .white
        navMenu1?.optionFont = .systemFont(ofSize: 13)
        navMenu1?.optionTextColor = .label
        navMenu1?.optionTextAlignment = .center
        navMenu1?.optionNumberOfLines = 0
        navMenu1?.optionLineColor = .white
        navMenu1?.optionIconSize = CGSize(width: 15, height: 15)
        
        
        ContainerView.addSubview(navMenu1!)
        
    }
}
extension BootomSheetVC:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
    func numberOfOptions(in menu: LMJDropdownMenu) -> UInt {
        return UInt(_menu1OptionTitles!.count)
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, heightForOptionAt index: UInt) -> CGFloat {
        return 30
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, titleForOptionAt index: UInt) -> String {
        return _menu1OptionTitles![Int(index)]
    }
    
    //MARK: -LMJDropdownMenuDelegate
    func dropdownMenu(_ menu: LMJDropdownMenu, didSelectOptionAt index: UInt, optionTitle title: String) {
        print("您选择了index：\(index),title: \(title)")
        currentTitle = title
    }
}
