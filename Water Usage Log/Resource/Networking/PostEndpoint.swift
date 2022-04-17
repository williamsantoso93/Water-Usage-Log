//
//  PostEndpoint.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

//MARK: - Post Data
extension Networking {
    func defaultResultIsSuccess(_ result: Result<DefaultResponse<Bool>, NetworkError>, _ isSuccess: Bool, completion: @escaping (_ isSuccess: Bool) -> Void) {
        DispatchQueue.main.async {
            switch result {
            case .success(_):
                return completion(isSuccess)
            case .failure(let failure):
                if isSuccess {
                    return completion(isSuccess)
                } else {
                    print(failure)
                    return completion(false)
                }
            }
        }
    }
    
    func postYearMonth(_ yearMonth: YearMonth, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: DatabaseID.yearMonthDatabaseID.rawValue),
            properties: Mapper.yearMonthLocalToRemote(yearMonth)
        )
        
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
    
    func postDailyLog(_ dailyLog: DailyLogModel, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = basePage
        
        let post = DefaultPost(
            parent: Parent(databaseID: DatabaseID.dailyLog.rawValue),
            properties: Mapper.dailyLogLocalToRemote(dailyLog)
        )        
        
        postData(to: urlString, postData: post) { (result: Result<DefaultResponse<Bool>, NetworkError>, response, dataResponse, isSuccess) in
            self.defaultResultIsSuccess(result, isSuccess) { isSuccess in
                return completion(isSuccess)
            }
        }
    }
}
