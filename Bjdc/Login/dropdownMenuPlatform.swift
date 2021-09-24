//
//  dropdownMenuPlatform.swift
//  BDJC-Test
//
//  Created by mbp on 2021/9/15.
//

import Foundation

extension LoginVC {
    func dropdownMenuPlatform() {
        platformMenueTitles = ["第一平台","第二平台","第三平台","海淀平台"]
        platformMenue = LMJDropdownMenu.init()
        let frame =  CGRect(x: 0, y: 0, width: self.platformView.bounds.size.width, height: 40)
        platformMenue?.frame = frame
        platformMenue?.dataSource = self
        platformMenue?.delegate   = self
        
        platformMenue?.layer.borderUIColor = .black
        platformMenue?.layer.borderWidth  = 0
        platformMenue?.layer.cornerRadius = 0
        
        platformMenue?.backgroundColor = .purple
        platformMenue?.title = platformMenueTitles![1]
        platformMenue?.titleBgColor = .systemBackground
        platformMenue?.titleFont = .boldSystemFont(ofSize: 18)
        platformMenue?.titleColor = .label
        platformMenue?.titleAlignment = .justified
        platformMenue?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        platformMenue?.rotateIcon = UIImage(systemName: "arrowtriangle.down.fill")!
        platformMenue?.rotateIconTint = .label
        platformMenue?.rotateIconSize = CGSize(width: 15, height: 15);
        platformMenue?.rotateIconMarginRight = 15;
        
        platformMenue?.optionBgColor = .systemBackground
        platformMenue?.optionFont = .systemFont(ofSize: 16)
        platformMenue?.optionTextColor = .label
        platformMenue?.optionTextAlignment = .left
        platformMenue?.optionNumberOfLines = 0
        platformMenue?.optionLineColor = .systemBackground
        platformMenue?.optionIconSize = CGSize(width: 15, height: 15)
        
        
        platformView.addSubview(platformMenue!)
        
    }
}
extension LoginVC:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
    func numberOfOptions(in menu: LMJDropdownMenu) -> UInt {
        return UInt(platformMenueTitles!.count)
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, heightForOptionAt index: UInt) -> CGFloat {
        return 30
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, titleForOptionAt index: UInt) -> String {
        return platformMenueTitles![Int(index)]
    }
    
    //MARK: -LMJDropdownMenuDelegate
    func dropdownMenu(_ menu: LMJDropdownMenu, didSelectOptionAt index: UInt, optionTitle title: String) {
        print("您选择了index：\(index),title: \(title)")
        if index == 0 {
            //第一平台，南京
            networkInterface = FIRST_BASE_URL
        }else if index == 1 {
            //第二平台，北京和平里，实验室
            networkInterface = SECOND_BASE_URL
        }else if index == 2 {
            //第三平台，测试
            networkInterface = THIRD_BASE_URL
        }else if index == 3 {
            //第四平台，海淀
            networkInterface = FOURTH_BASE_URL
        }
        
        
    }
}
