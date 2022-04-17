//
//  Mapper.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

struct Mapper {
    //MARK: - YearMonth
    static func mapYearMonthListRemoteToLocal(_ remote: [ResultProperty<YearMonthProperty>]) -> [YearMonth] {
        remote.map { result in
            yearMonthListRemoteToLocal(result.id, result.properties)
        }
    }
    
    static func yearMonthListRemoteToLocal(_ id: String, _ remote: YearMonthProperty) -> YearMonth {
        YearMonth(
            id: id,
            name: remote.name.title.first?.text.content ?? "",
            month: remote.month.select?.name ?? "",
            year: remote.year.select?.name ?? ""
        )
    }
    
    static func mapYearMonthLocalToRemote(_ local: [YearMonth]) -> [YearMonthProperty] {
        local.map { result in
            yearMonthLocalToRemote(result)
        }
    }
    
    static func yearMonthLocalToRemote(_ local: YearMonth) -> YearMonthProperty {
        YearMonthProperty(
            name: TitleProperty(title: [Title(text: TextContent(content: local.name))]),
            month: SingleSelectProperty(select: Select(name: local.month)),
            year: SingleSelectProperty(select: Select(name: local.year))
        )
    }
    
    //MARK: - DailyLog
    static func mapDailyLogListRemoteToLocal(_ remote: [ResultProperty<DailyLogProperty>]) -> [DailyLogModel] {
        remote.map { result in
            dailyLogRemoteToLocal(result.id, result.properties)
        }
    }
    
    static func dailyLogRemoteToLocal(_ id: String, _ remote: DailyLogProperty) -> DailyLogModel {
        DailyLogModel(
            blockID: id,
            id: remote.id?.title.first?.text.content ?? "",
            yearMonth: nil,
            yearMonthID: remote.yearMonth?.relation.first?.id,
            date: remote.date?.date.start.toDate(),
            value: remote.value?.number,
            usage: remote.usage?.number,
            days: remote.days?.number
        )
    }
    
    static func mapDailyLogLocalToRemote(_ local: [DailyLogModel]) -> [DailyLogProperty] {
        local.map { result in
            dailyLogLocalToRemote(result)
        }
    }
    
    static func dailyLogLocalToRemote(_ local: DailyLogModel) -> DailyLogProperty {
        DailyLogProperty(
            id: TitleProperty(title: [Title(text: TextContent(content: local.id))]),
            yearMonth: RelationProperty(relation: [Relation(id: local.yearMonthID ?? "")]),
            value: NumberProperty(number: local.value ?? 0),
            date: DateProperty(date: DateModel(start: local.date?.toString() ?? "")),
            usage: NumberProperty(number: local.usage ?? 0),
            days: NumberProperty(number: local.days ?? 0)
        )
    }
    
    static func errorMessageRemoteToLocal(_ remote: ErrorResponse) -> ErrorMessage {
        ErrorMessage(
            title: remote.code,
            message: remote.message
        )
    }
    
    
    //MARK: - To Property
    
    static func textToRichTextProperty(_ text: String?) -> RichTextProperty? {
        guard let text = text else {
            return nil
        }
        
        guard !text.isEmpty else {
            return RichTextProperty(richText: [])
        }
        
        return RichTextProperty(richText: [RichText(type: "text", text: TextContent(content: text))])
    }
    
    static func textToSingleSelectProperty(_ text: String?) -> SingleSelectProperty? {
        guard let text = text else {
            return nil
        }
        guard !text.isEmpty else {
            return nil
        }
        
        return SingleSelectProperty(select: Select(name: text))
    }
    
    static func stringsToMultiSelectProperty(_ strings: [String]?) -> MultiSelectProperty? {
        guard let strings = strings else { return nil }
        guard !strings.isEmpty else { return nil }
        
        let map = strings.map { result in
            Select(name: result)
        }
        
        return MultiSelectProperty(multiSelect: map)
    }
    
    static func numberToNumberProperty(_ value: Double?) -> NumberProperty? {
        guard let value = value else {
            return nil
        }
        guard value != 0 else {
            return nil
        }
        
        return NumberProperty(number: value)
    }
}
