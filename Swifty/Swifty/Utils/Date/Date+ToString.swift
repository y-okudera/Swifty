//
//  Date+ToString.swift
//  Swifty
//
//  Created by Yuki Okudera on 2020/03/23.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation

extension Date {
    func toString(dateFormat: DateFormat) -> String {
        let dateFormatter = DateFormatter.sharedFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        dateFormatter.locale = .jaJp
        dateFormatter.timeZone = .gmt
        return dateFormatter.string(from: self)
    }
}

