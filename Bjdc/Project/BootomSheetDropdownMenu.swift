//
//  BootomSheetDropdownMenu.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import Foundation

extension BootomSheetVC{

    
    func dropdownMenuBootomSheet() {
        _menu1OptionTitles = projectTitles
        print("_menu1OptionTitles",projectTitles)
        
        navMenu1 = LMJDropdownMenu.init()
        NavMenu1 = navMenu1
        let frame =  CGRect(x: 40, y: 2, width: self.view.bounds.size.width-80, height: 40)
        navMenu1?.frame = frame
        navMenu1?.dataSource = self
        navMenu1?.delegate   = self
        
        navMenu1?.layer.borderUIColor = .black
        navMenu1?.layer.borderWidth  = 0
        navMenu1?.layer.cornerRadius = 0
        
        navMenu1?.title = projectTitles[0]
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
        //MARK: -当前工程索引
        CurrentProject = Int(index)
        //MARK: -标题
        currentTitle = title
        //MARK: -监测点总数
        stationNums.text = pssTotal[Int(index)]
        //MARK: -btn
        let warning = NSAttributedString(string: "警告\n\(pssWarning[Int(index)])")
        warningBtn.setAttributedTitle(warning, for: .normal)
        let total = NSAttributedString(string: "总数\n\(pssTotal[Int(index)])")
        totalBtn.setAttributedTitle(total, for: .normal)
        let online = NSAttributedString(string: "在线\n\(pssOnline[Int(index)])")
        onlineBtn.setAttributedTitle(online, for: .normal)
        let offline = NSAttributedString(string: "离线\n\(pssOffline[Int(index)])")
        offlineBtn.setAttributedTitle(offline, for: .normal)
        let error = NSAttributedString(string: "故障\n\(pssError[Int(index)])")
        errorBtn.setAttributedTitle(error, for: .normal)
        
        tableView.reloadData()
    }
}
