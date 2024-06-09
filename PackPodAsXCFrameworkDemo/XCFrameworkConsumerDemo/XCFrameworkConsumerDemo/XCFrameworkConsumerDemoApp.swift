//
//  XCFrameworkConsumerDemoApp.swift
//  XCFrameworkConsumerDemo
//
//  Created by Ficow on 2024/6/9.
//

import SwiftUI

// import the dependency via xcframework, instead of pod
import FicowPod

@main
struct XCFrameworkConsumerDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    FicowPodEntry.hello() // FicowPod method
                }
        }
    }
}
