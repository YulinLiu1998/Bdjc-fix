//
//  dropdownName.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/8.
//

import Foundation
extension BootomSheetChartVC{
    func dropdownName(){
        nameDropdownTitles = stationNames[CurrentProject!]
        nameDropdown = LMJDropdownMenu.init()
        let frame =  CGRect(x: 5, y: 2, width: self.menuView.bounds.size.width/2 - 40, height: 40)
        nameDropdown?.frame = frame
        nameDropdown?.dataSource = self
        nameDropdown?.delegate   = self
        
        nameDropdown?.layer.borderUIColor = .black
        nameDropdown?.layer.borderWidth  = 0
        nameDropdown?.layer.cornerRadius = 0
        
        nameDropdown?.title = currenSelectedStation!
        nameDropdown?.titleBgColor = .systemBackground
        nameDropdown?.titleFont = .boldSystemFont(ofSize: 15)
        nameDropdown?.titleColor = .label
        nameDropdown?.titleAlignment = .center
        nameDropdown?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        nameDropdown?.rotateIcon = UIImage(systemName: "arrowtriangle.down.fill")!
        nameDropdown?.rotateIconTint = .label
        nameDropdown?.rotateIconSize = CGSize(width: 15, height: 15);
        nameDropdown?.rotateIconMarginRight = 15;
        
        nameDropdown?.optionBgColor = .systemBackground
        nameDropdown?.optionFont = .systemFont(ofSize: 13)
        nameDropdown?.optionTextColor = .label
        nameDropdown?.optionTextAlignment = .center
        nameDropdown?.optionNumberOfLines = 0
        nameDropdown?.optionLineColor = .systemBackground
        nameDropdown?.optionIconSize = CGSize(width: 15, height: 15)
        
        
        menuView.addSubview(nameDropdown!)    }
}
