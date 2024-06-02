//
//  ContentView.swift
//  ObservationDemo
//
//  Created by Ficow on 2024/6/2.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var vm: RootViewModel
    @Environment(RootViewState.self) var viewState

    var body: some View {
        NavigationView {
            VStack {
                Text(viewState.text)
                Divider()
                EditView(viewState: viewState)
                Divider()
                Text(viewState.log)
            }
        }
        .task {
            vm.updateText()
        }
    }

}

struct EditView: View {
    @Bindable var viewState: RootViewState // Note: binding from observable macro

    var body: some View {
        TextField("Update text", text: $viewState.text)
    }
}

#Preview {
    ContentView()
        .environmentObject(RootViewModel.shared)
        .environment(RootViewModel.shared.viewState)
}
