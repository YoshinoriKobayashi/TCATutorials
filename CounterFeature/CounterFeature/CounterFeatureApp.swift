//
//  CounterFeatureApp.swift
//  TCA
//
//  Created by Yoshinori Kobayashi on 2023/09/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct CounterFeatureApp: App {
    
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            CounterView(store: CounterFeatureApp.store)
        }
    }
}

