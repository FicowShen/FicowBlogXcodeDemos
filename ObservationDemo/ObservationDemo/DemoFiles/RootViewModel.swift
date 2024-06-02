//
//  RootViewModel.swift
//  ObservationDemo
//
//  Created by Ficow on 2024/6/2.
//

import Foundation

// Note: old way using ObservableObject
class RootViewModel: ObservableObject {

    static let shared = RootViewModel()

    private(set) var viewState = RootViewState()

    init() {
        observeText()
    }

    private func observeText() {
        AsyncStream.observeOnMainActor {
            self.viewState.text
        } newValue: { text in
            // Note: this can also get the initial value
            self.viewState.log = "Detect new text: \(text)"
        }

    }

    func updateText() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.viewState.text = "Updated text"
        }
    }
}
