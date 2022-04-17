//
//  GetEndpoint.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

//MARK: - Get Data
extension Networking {
    func defaultReturnData<T: Codable>(_ result: Result<DefaultResponse<T>, NetworkError>, completion: @escaping (Result<DefaultResponse<T>, NetworkError>) -> Void) {
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                return completion(.success(data))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
    
    func getYearMonth(startCursor: String? = nil, completion: @escaping (Result<DefaultResponse<YearMonthProperty>, NetworkError>) -> Void) {
        let urlString = baseDatabase + DatabaseID.yearMonthDatabaseID.rawValue + "/query"
        
        let post = Query(
            startCursor: startCursor,
            sorts: [
                Sort(property: "Name", direction: SortDirection.ascending.rawValue)
            ]
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<YearMonthProperty>, NetworkError>, response, dataResponse, isSuccess) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    return completion(.success(data))
                case .failure(let error):
                    return completion(.failure(error))
                }
            }
        }
    }
    
    func getLatestDailyLog(startCursor: String? = nil, completion: @escaping (Result<DefaultResponse<DailyLogProperty>, NetworkError>) -> Void) {
        let urlString = baseDatabase + DatabaseID.dailyLog.rawValue + "/query"
        
        let post = Query(
            startCursor: startCursor,
            pageSize: 1,
            sorts: [
                Sort(property: "Date", direction: SortDirection.descending.rawValue),
                Sort(property: "Created Time", direction: SortDirection.descending.rawValue),
            ]
        )
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<DailyLogProperty>, NetworkError>, response, dataResponse, isSuccess) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    return completion(.success(data))
                case .failure(let error):
                    return completion(.failure(error))
                }
            }
        }
    }
}
