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
}
