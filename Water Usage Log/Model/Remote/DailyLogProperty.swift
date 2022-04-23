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
    let value: NumberProperty?
    let date: DateProperty?
    let usage: NumberProperty?
    let days: NumberProperty?
    let usagePerDay: FormulaProperty?
    
    enum CodingKeys: String, CodingKey {
        case id
        case yearMonth = "Year/Month"
        case value = "Value"
        case date = "Date"
        case usage = "Usage"
        case days = "Days"
        case usagePerDay = "Usage Per day"
    }
}
