//
//  Demoable.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import Foundation
import FittedSheets

protocol Demoable {
    static var name: String { get }
    static func openDemo(from parent: UIViewController, in view: UIView?)
}

extension Demoable {
    static func addSheetEventLogging(to sheet: SheetViewController) {
        let previousDidDismiss = sheet.didDismiss
        sheet.didDismiss = {
            print("did dismiss")
            previousDidDismiss?($0)
        }
        
        let previousShouldDismiss = sheet.shouldDismiss
        sheet.shouldDismiss = {
            print("should dismiss")
            return previousShouldDismiss?($0) ?? true
        }
        
        let previousSizeChanged = sheet.sizeChanged
        sheet.sizeChanged = { sheet, size, height in
            print("Changed to \(size) with a height of \(height)")
            previousSizeChanged?(sheet, size, height)
        }
    }
}
