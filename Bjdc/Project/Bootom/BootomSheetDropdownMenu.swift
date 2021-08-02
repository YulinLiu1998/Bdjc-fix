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
        navMenu1?.titleBgColor = .systemBackground
        navMenu1?.titleFont = .boldSystemFont(ofSize: 15)
        navMenu1?.titleColor = .label
        navMenu1?.titleAlignment = .center
        navMenu1?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        navMenu1?.rotateIcon = UIImage(systemName: "arrowtriangle.down.fill")!
        navMenu1?.rotateIconTint = .label
        navMenu1?.rotateIconSize = CGSize(width: 15, height: 15);
        navMenu1?.rotateIconMarginRight = 15;
        
        navMenu1?.optionBgColor = .systemBackground
        navMenu1?.optionFont = .systemFont(ofSize: 13)
        navMenu1?.optionTextColor = .label
        navMenu1?.optionTextAlignment = .center
        navMenu1?.optionNumberOfLines = 0
        navMenu1?.optionLineColor = .systemBackground
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
        //print("CurrentProject",CurrentProject as Any)
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
        
        //每次选择下拉菜单前都要重置列表显示信息
        CurrentSelectedStatus = "Total"
        //设置当前选中状态的显示行数
        tableRows = Int(pssTotal[CurrentProject!])!
        tableView.reloadData()
        guard ProjectList![CurrentProject!]["StationList"].count != 0 else {
            let alert = UIAlertController(title: "无法显示标记", message: "当前工程检测点总数为0，无法显示标记！", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "确认", style: .default){_ in
                self.delegate?.removeAnnotationsMapView()
            }
            
            alert.addAction(action1)
            
            self.present(alert,animated: true)
            print("当前工程检测点总数为0，无法显示标记！")
            return
        }
        guard ProjectList![CurrentProject!]["StationList"].count != 0 else {
            self.alertWarning(Message: "当前工程检测点总数为0，无法显示标记！")
            print("当前工程检测点总数为0，无法显示标记！")
            return
        }
        
        guard StationLongitudes[CurrentProject!].count != 0 || StationLatitudes[CurrentProject!].count != 0  else {
            self.alertWarning(Message: "当前工程检测点无位置信息，无法显示标记！")
            print("当前工程检测点无位置信息，无法显示标记！")
            return
        }
        delegate?.updateMapView()
        
        
        
    }
    func alertWarning(Message:String) {
        let alert = UIAlertController(title: "无法显示标记", message: Message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "确认", style: .cancel){_ in
            self.delegate?.removeAnnotationsMapView()
        }

        alert.addAction(action1)

        self.present(alert,animated: true)
    }
}
