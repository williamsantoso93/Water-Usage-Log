//
//  Water_Usage_LogApp.swift
//  Water Usage Log
//
//  Created by William Santoso on 17/04/22.
//

import SwiftUI

@main
struct Water_Usage_LogApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
