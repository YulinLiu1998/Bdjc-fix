//
//  DateTableDropdownMenu.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import Foundation


extension DateTableVC{
    func dropdownMenuDateTable() {
        _menu1OptionTitles = ["Option1","Option2","Option3","Option4","Option5"]
        _menu1OptionIcons = ["icon1","icon2","icon3","icon4","icon5"]
        
        
        // ----------------------- navigation bar menu ---------------------------
        
        navMenu = LMJDropdownMenu.init()
        NavMenu = navMenu
        
//        self.view.bounds.size.width - 160
        let frame =  CGRect(x: 40, y: 2, width: self.view.bounds.size.width-80, height: 40)
        navMenu?.frame = frame
        navMenu?.dataSource = self
        navMenu?.delegate   = self
        
        navMenu?.layer.borderUIColor = .black
        navMenu?.layer.borderWidth  = 0
        navMenu?.layer.cornerRadius = 0
        
        navMenu?.title = "Option1"
        currentTitle = navMenu?.title
        navMenu?.titleBgColor = .white
        navMenu?.titleFont = .boldSystemFont(ofSize: 15)
        navMenu?.titleColor = .label
        navMenu?.titleAlignment = .center
        navMenu?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        navMenu?.rotateIcon = UIImage(systemName: "arrowtriangle.down.fill")!
        navMenu?.rotateIconSize = CGSize(width: 15, height: 15);
        navMenu?.rotateIconMarginRight = 15;
        
        navMenu?.optionBgColor = .white
        navMenu?.optionFont = .systemFont(ofSize: 13)
        navMenu?.optionTextColor = .label
        navMenu?.optionTextAlignment = .center
        navMenu?.optionNumberOfLines = 0
        navMenu?.optionLineColor = .white
        navMenu?.optionIconSize = CGSize(width: 15, height: 15)
//        self.navigationController?.navigationBar.addSubview(navMenu!)
        self.navigationController?.navigationBar.addSubview(navMenu!)
    }
}


extension DateTableVC:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
    
    //MARK: -LMJDropdownMenuDataSource
    
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
