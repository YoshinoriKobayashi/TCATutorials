//
//  ContactsFeatureApp.swift
//  ContactsFeature
//
//  Created by Yoshinori Kobayashi on 2023/10/02.
//

import SwiftUI
import ComposableArchitecture

@main
struct ContactsFeatureApp: App {
    
    static let store = Store(initialState: ContactsFeature.State()) {
        ContactsFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            ContactsView(store: ContactsFeatureApp.store)
        }
    }
}
