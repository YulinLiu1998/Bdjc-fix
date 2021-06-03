//
//  Constant-req.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/6/1.
//

import Foundation
import SwiftyJSON


let dataLoadGroup = DispatchGroup()
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
var CurrentProject:Int?
var CurrentSelectedStatus:String?
//项目总数
var ProjectNum:Int?
//项目信息获取时间
var currentTime:String?
//项目名称
var projectTitles = [String]()
//站点名称数据
var stationNames = [[String]]()
//站点状态
var stationStations = [[String]]()
//站点类型  1:基准站  2:移动站
var stationTypes = [[String]]()
//最新活跃时间
var stationLastTime = [[String]]()
//projectStationStatus
var pssWarning = [String]()
var pssError = [String]()
var pssOffline = [String]()
var pssOnline = [String]()
var pssTotal = [String]()
