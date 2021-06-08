//
//  dropdownDate.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/8.
//

import Foundation
extension BootomSheetChartVC{
    func dropdownDate(){
        dateDropdownTitles = ["最近1小时","最近6小时","最近12小时","本日","一周","一月","一年","自定义时间"]
        dateDropdown = LMJDropdownMenu.init()
        let frame =  CGRect(x: self.menuView.bounds.size.width/2 + 5, y: 2, width: self.menuView.bounds.size.width/2 - 40, height: 40)
        dateDropdown?.frame = frame
        dateDropdown?.dataSource = self
        dateDropdown?.delegate   = self
        
        dateDropdown?.layer.borderUIColor = .black
        dateDropdown?.layer.borderWidth  = 0
        dateDropdown?.layer.cornerRadius = 0
        
        dateDropdown?.title = dateDropdownTitles![3]
        dateDropdown?.titleBgColor = .white
        dateDropdown?.titleFont = .boldSystemFont(ofSize: 15)
        dateDropdown?.titleColor = .label
        dateDropdown?.titleAlignment = .center
        dateDropdown?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        dateDropdown?.rotateIcon = UIImage(systemName: "arrowtriangle.down.fill")!
        dateDropdown?.rotateIconSize = CGSize(width: 15, height: 15);
        dateDropdown?.rotateIconMarginRight = 15;
        
        dateDropdown?.optionBgColor = .white
        dateDropdown?.optionFont = .systemFont(ofSize: 13)
        dateDropdown?.optionTextColor = .label
        dateDropdown?.optionTextAlignment = .center
        dateDropdown?.optionNumberOfLines = 0
        dateDropdown?.optionLineColor = .white
        dateDropdown?.optionIconSize = CGSize(width: 15, height: 15)
        
        
        menuView.addSubview(dateDropdown!)
    }
}


