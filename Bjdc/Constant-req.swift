//
//  Constant-req.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/1.
//

import Foundation
import SwiftyJSON


var TokenTimer : Timer?
var SessionInvalid:Bool = true
//地图
var MapView: MAMapView!
//StationUUID
var StationUUID:String?
//报告
var StationReport:JSON?
//当前下拉菜单题目
var currentDrodownTitle:String?

//MARK: -网络接口
//http://39.96.80.62/bdjc/API/doSession.php
//http://172.18.7.86/dist/API/doSession.php
var networkInterface = "http://39.96.80.62/bdjc/API/"
//第一平台，南京
let FIRST_BASE_URL = "http://39.107.99.169/bdjc/API/"
//第二平台，北京和平里，实验室
let SECOND_BASE_URL = "http://39.96.80.62/bdjc/API/"
//第三平台，测试
let THIRD_BASE_URL = "http://172.18.7.86/dist/API/"
//第四平台，海淀
let FOURTH_BASE_URL = "http://140.210.9.229/bdjc/API/";
//MARK: -获取访问令牌
var AccessToken:String?
var ExpireTimestamp:Int?
//MARK: -校验用户会话
var SessionUUID:String = "00000000-0000-0000-0000-000000000000"

//MARK: -账号密码登录
var SessionUUIDmd5:String?
var Username:String?
var Password:String?
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
//MARK: -Chart
var ChartData:JSON?
var DataTime:[String]?
var DataTimestamp:[String]?
var GNSSFilterInfoN:[Double]?
var GNSSFilterInfoE:[String]?
var GNSSFilterInfoH:[String]?
var GNSSFilterInfoDeltaD:[String]?
var GNSSFilterInfoDeltaH:[String]?
//当前选中的站点
var currenSelectedStation:String?

//MARK: -请求图表数据时间
var StartTime:String?
var EndTime:String?
//自定义时间
var CustomStartTime:String?
var CustomEndTime:String?
//数据表时间间隔
var TimeDateInterval = [String]()
//一小时
var TimeInterval_oneHour = [String]()
//六小时
var TimeInterval_sixHours = [String]()
//十二小时
var TimeInterval_twelveHours = [String]()
//本日
var TimeInterval_day = [String]()
//大于一天小于七天
var TimeInterval_MoreDays = [String]()
//一周
var TimeInterval_Sevenday = [String]()
//大于等于七天小于一个月
var TimeInterval_MoreSevendays = [String]()
//一月
var TimeInterval_Month = [String]()
//大于等于一个月小于一年
var TimeInterval_MoreMonths = [String]()
//一年
var TimeInterval_Year = [String]()
//大于等于一年
var TimeInterval_MoreYears = [String]()
//自定义
var TimeInterval_Custom = [String]()
//MARK: - 下拉时间栏
//设置在选择下拉时间栏时对应的x轴数据


var TimeIntervalKind = [TimeInterval_oneHour,TimeInterval_sixHours,TimeInterval_twelveHours,TimeInterval_day,TimeInterval_Sevenday,TimeInterval_Month,TimeInterval_Year,TimeInterval_Custom]
//设置下拉时间栏对应的索引 自定义状态值均为0（表示代设定）
var CurrentTimeInterval:Int?
//自定义状态
var CustomStatus:String?
//[30,180,360,720,1008,744,182]
//[60,360,720,1440,2016,1488,365]
//设置可见点数
var VisibleXRangeMaximum = [35,190,360,750,500,500,120,0]
//设置请求数据的间隔 用于请求函数
var DeltaTime = ["60","60","120","60","300","1800","86400","0"]
//设置x轴对应的最大值
var AxisMaximum = [65,370,380,1500,2050,1500,370,0]
var AxisGranularity = [5,30,30,120,144,48,1,0]


var dateStartComponents: DateComponents?
var dateEndComponents: DateComponents?
var DiffDateComponents: DateComponents?

//Range
var heartRange:Int?
var HeartChart:Bool?
