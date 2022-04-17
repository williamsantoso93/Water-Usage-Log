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
    
    func saveLog(completion: @escaping (_ isSuccess: Bool) -> Void) {
        do {
            var dailyLog = DailyLogModel(blockID: "")
            dailyLog.value = try Validation.numberTextField(valueString)
            dailyLog.date = date
            
            YearMonthCheck.shared.getYearMonthID(date) { id in
                dailyLog.yearMonthID = id
                
                self.isLoading = true
                
                Networking.shared.getLatestDailyLog { (result: Result<DefaultResponse<DailyLogProperty>, NetworkError>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data) :
                            if let result = data.results.first {
                                let lastDailyLog = Mapper.dailyLogRemoteToLocal(result.id, result.properties)
                                
                                if let days = lastDailyLog.date?.daysBetween(end: self.date) {
                                    dailyLog.days = Double(days)
                                }
                                if let lastValue = lastDailyLog.value {
                                    dailyLog.usage = self.value - lastValue
                                }
                            }
                            
                            Networking.shared.postDailyLog(dailyLog) { isSuccess in
                                self.isLoading = false
                                return completion(isSuccess)
                            }
                        case .failure(let error) :
                            self.isLoading = false
                            print(error.localizedDescription)
                        }
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
