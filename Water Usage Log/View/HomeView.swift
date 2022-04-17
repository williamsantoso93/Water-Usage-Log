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
                NumberTextFiedForm(title: "Input Log", prompt: "0.6", value: $viewModel.valueString)
                DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
            }
            .navigationTitle("PAM Log")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveLog { isSuccess in
                            
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
