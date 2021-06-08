//
//  drpdownDelegate.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/8.
//

import Foundation
extension BootomSheetChartVC:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
    func numberOfOptions(in menu: LMJDropdownMenu) -> UInt {
        var count:UInt?
        if menu == dateDropdown {
            count =  UInt(dateDropdownTitles!.count)
        }else if menu == nameDropdown {
            count = UInt(nameDropdownTitles!.count)
        }
        return count!
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, heightForOptionAt index: UInt) -> CGFloat {
        return 30
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, titleForOptionAt index: UInt) -> String {
        var titles:String?
        if menu == dateDropdown {
            titles =  dateDropdownTitles![Int(index)]
        }else if menu == nameDropdown {
            titles = nameDropdownTitles![Int(index)]
        }
        return titles!
    }
    
    //MARK: -LMJDropdownMenuDelegate
    func dropdownMenu(_ menu: LMJDropdownMenu, didSelectOptionAt index: UInt, optionTitle title: String) {
        if menu == dateDropdown{
            print("dateDropdown")
            print("您选择了index：\(index),title: \(title)")
        }else if menu == nameDropdown{
            print("nameDropdown")
            print("您选择了index：\(index),title: \(title)")
        }
        
        
        
    }
}
