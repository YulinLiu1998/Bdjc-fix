//
//  UserConfig.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/7/20.
//

import Foundation
import RealmSwift

class UserAccountReaml:Object{
    @objc dynamic var account = ""
    @objc dynamic var password = ""
    @objc dynamic var LoginStatues = "false"
}

class TokenRealm:Object{
    @objc dynamic var TokenString = ""
    @objc dynamic var TokenAccessTime = Date()
}

class SessionRealm:Object{
    @objc dynamic var SessionString = ""
    @objc dynamic var SessionAccessTime = Date()
}
