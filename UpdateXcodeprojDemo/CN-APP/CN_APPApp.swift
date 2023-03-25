//
//  CN_APPApp.swift
//  CN-APP
//
//  Created by Ficow on 2023/3/23.
//

import SwiftUI

@main
struct CN_APPApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
#if FICOW_ON
            addFICOWONView()
#endif
        }
    }

    func addFICOWONView() -> some View {
        CNViewController().viewDidLoad()
        return Color.red
    }
}
