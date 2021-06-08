//
//  Constant-req.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/1.
//

import Foundation
import SwiftyJSON
var MapView: MAMapView!

//MARK: -获取访问令牌
var AccessToken:String?
var ExpireTimestamp:Int?
//MARK: -校验用户会话
var SessionUUID:String = "00000000-0000-0000-0000-000000000000"

//MARK: -账号密码登录
var SessionUUIDmd5:String?
var Username:String?

//MARK: -工程项目
var ProjectList:JSON?
//当前项目
var CurrentProject:Int?
//当前选中状态
var CurrentSelectedStatus:String?
//项目总数
var ProjectNum:Int?
//项目信息获取时间
var currentTime:String?
//项目名称
var projectTitles = [String]()
//MARK: -Total
    //站点名称数据
    var stationNames = [[String]]()
    //站点状态
    var stationStatus = [[String]]()
    //站点类型  1:基准站  2:移动站
    var stationTypes = [[String]]()
    //最新活跃时间
    var stationLastTime = [[String]]()
    //纬度
    var StationLatitudes = [[String]]()
    //经度
    var StationLongitudes = [[String]]()
//MARK: -Online
    var OnlineNames = [[String]]()
    //站点状态
    var OnlineStatus = [[String]]()
    //站点类型  1:基准站  2:移动站
    var OnlineTypes = [[String]]()
    //最新活跃时间
    var OnlineLastTime = [[String]]()
//MARK: -Warning
//站点名称数据
    var WarningNames = [[String]]()
    //站点状态
    var WarningStatus = [[String]]()
    //站点类型  1:基准站  2:移动站
    var WarningTypes = [[String]]()
    //最新活跃时间
    var WarningLastTime = [[String]]()
//MARK: -Error
    var ErrorNames = [[String]]()
    //站点状态
    var ErrorStatus = [[String]]()
    //站点类型  1:基准站  2:移动站
    var ErrorTypes = [[String]]()
    //最新活跃时间
    var ErrorLastTime = [[String]]()
//MARK: -Offline
    var OfflineNames = [[String]]()
    //站点状态
    var OfflineStatus = [[String]]()
    //站点类型  1:基准站  2:移动站
    var OfflineTypes = [[String]]()
    //最新活跃时间
    var OfflineLastTime = [[String]]()
//projectStationStatus
var pssWarning = [String]()
var pssError = [String]()
var pssOffline = [String]()
var pssOnline = [String]()
var pssTotal = [String]()



