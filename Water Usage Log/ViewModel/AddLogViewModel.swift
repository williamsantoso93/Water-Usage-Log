//
//  AddLogViewModel.swift
//  Water Usage Log
//
//  Created by William Santoso on 17/04/22.
//

import Foundation

class AddLogViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var valueString = ""
    var value: Double {
        valueString.toDouble() ?? 0
    }
    @Published var date = Date()
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    @Published var latestDailyLog = DailyLogModel(blockID: "")
    
    init() {
        fetchLatest()
    }
    
    func fetchLatest() {
        isLoading = true
        getLatestDailyLog { _ in
            self.isLoading = false
        }
    }
    
    func getLatestDailyLog(completion: @escaping (DailyLogModel) -> Void) {
        Networking.shared.getLatestDailyLog { (result: Result<DefaultResponse<DailyLogProperty>, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data) :
                    if let result = data.results.first {
                        let latestDailyLog = Mapper.dailyLogRemoteToLocal(result.id, createdTime: result.createdTime, result.properties)
                        self.latestDailyLog = latestDailyLog
                        
                        return completion(latestDailyLog)
                    }
                case .failure(let error) :
                    self.isLoading = false
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func saveLog(completion: @escaping (_ isSuccess: Bool) -> Void) {
        do {
            var dailyLog = DailyLogModel(blockID: "")
            dailyLog.value = try Validation.numberTextField(valueString)
            let date = Date()
            
            YearMonthCheck.shared.getYearMonthID(date) { id in
                dailyLog.yearMonthID = id
                
                self.isLoading = true
                
                self.getLatestDailyLog { latestDailyLog in
                    dailyLog.createdDate = Date()
                    dailyLog.previousDate = latestDailyLog.createdDate
                    dailyLog.previousvalue = latestDailyLog.value
                    
                    Networking.shared.postDailyLog(dailyLog) { isSuccess in
                        self.isLoading = false
                        if isSuccess {
                            self.valueString = ""
                        }
                        return completion(isSuccess)
                    }
                }
            }
        } catch let error {
            if let error = error as? ValidationError {
                if let errorMessage = error.errorMessage {
                    self.errorMessage = errorMessage
                    isShowErrorMessage = true
                }
            }
        }
    }
}
