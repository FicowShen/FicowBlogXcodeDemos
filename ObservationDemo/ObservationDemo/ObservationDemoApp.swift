//
//  ObservationDemoApp.swift
//  ObservationDemo
//
//  Created by Ficow on 2024/6/2.
//

import SwiftUI

@main
struct ObservationDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(RootViewModel.shared) // Note: old way using ObservableObject
                .environment(RootViewModel.shared.viewState) // Note: new way using Observable macro
        }
    }
}
