//
//  HomeView.swift
//  Water Usage Log
//
//  Created by William Santoso on 17/04/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var globalData = GlobalData.shared
    @StateObject var viewModel = AddLogViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NumberTextFiedForm(title: "Input Log", prompt: "0.6", value: $viewModel.valueString)
                } header: {
                    Text("Input")
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Date : \((viewModel.latestDailyLog.createdTime ?? Date()).toString(format: "yyyy-MM-dd hh:mm"))")
                        Text("value : \((viewModel.latestDailyLog.value ?? 0).splitDigit())")
                        Text("usage : \((viewModel.latestDailyLog.usage ?? 0).splitDigit())")
                        Text("days : \((viewModel.latestDailyLog.days ?? 0).splitDigit())")
                        Text("usagePerDay : \((viewModel.latestDailyLog.usagePerDay ?? 0).splitDigit())")
                    }
                } header: {
                    Text("Previous Dialy Log")
                }
            }
            .refreshable {
                viewModel.fetchLatest()
            }
            .navigationTitle("PAM Log")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveLog { isSuccess in
                            if isSuccess {
                                viewModel.fetchLatest()
                            }
                        }
                    }
                }
            }
            .showErrorAlert(isShowErrorMessageAlert: $viewModel.isShowErrorMessage, errorMessage: viewModel.errorMessage)
            .networkErrorAlert()
            .loadingView(globalData.isLoadingYearMonths, isNeedDisable: true)
            .loadingView(viewModel.isLoading, isNeedDisable: true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
