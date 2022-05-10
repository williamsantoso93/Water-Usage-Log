//
//  DailyLogModel.swift
//  Water Usage Log
//
//  Created by William Santoso on 17/04/22.
//

import Foundation

struct DailyLogModel {
    var blockID: String
    var id: String = UUID().uuidString
    var yearMonth: String?
    var yearMonthID: String? = nil
    var createdDate: Date?
    var value: Double?
    var previousDate: Date?
    var previousvalue: Double?
    var usage: Double?
    var days: Double?
    var usagePerDay: Double?
}
