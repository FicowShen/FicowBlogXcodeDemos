//
//  RootViewState.swift
//  ObservationDemo
//
//  Created by Ficow on 2024/6/2.
//

import Foundation

// Note: new way using Observable macro
@Observable
class RootViewState {
    var text = "Initial text"
    var log = ""
}
