//
//  LiveActivityDemoApp.swift
//  LiveActivityDemo
//
//  Created by Ficow on 2024/1/21.
//

import SwiftUI

@main
struct LiveActivityDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
