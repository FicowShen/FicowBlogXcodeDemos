//
//  PackPodAsXCFrameworkDemoApp.swift
//  PackPodAsXCFrameworkDemo
//
//  Created by Ficow on 2024/6/8.
//

import SwiftUI
import FicowPod

@main
struct PackPodAsXCFrameworkDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    // set ENABLE_USER_SCRIPT_SANDBOXING to NO for app target in Build Settings
                    //
                    // to avoid below error:
                    // error: Sandbox: rsync(50114) deny(1) file-write-create
                    //
                    // reference:
                    // https://stackoverflow.com/questions/76590131/error-while-build-ios-app-in-xcode-sandbox-rsync-samba-13105-deny1-file-w
                    FicowPodEntry.hello()
                }
        }
    }
}
