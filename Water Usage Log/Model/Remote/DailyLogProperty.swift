//
//  DailyLogProperty.swift
//  Water Usage Log
//
//  Created by William Santoso on 17/04/22.
//

import Foundation

// MARK: - DailyLogProperty
struct DailyLogProperty: Codable {
    let id: TitleProperty?
    let yearMonth: RelationProperty?
    let createdDate: DateProperty?
    let value: NumberProperty?
    let previousDate: DateProperty?
    let previousvalue: NumberProperty?
    let usage: FormulaProperty?
    let days: FormulaProperty?
    let usagePerDay: FormulaProperty?
    
    enum CodingKeys: String, CodingKey {
        case id
        case yearMonth = "Year/Month"
        case createdDate = "Created Date"
        case value = "Value"
        case previousDate = "Previous Date"
        case previousvalue = "Previous Value"
        case usage = "Usage"
        case days = "Days"
        case usagePerDay = "Usage Per day"
    }
}
