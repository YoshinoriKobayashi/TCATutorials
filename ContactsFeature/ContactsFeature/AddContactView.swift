//
//  AddContactView.swift
//  ContactsFeature
//
//  Created by Yoshinori Kobayashi on 2023/10/02.
//

import SwiftUI
import ComposableArchitecture

struct AddContactView: View {
    let store: StoreOf<AddContactFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { ViewStore in 
            Form {
                TextField("Name", text: ViewStore.binding(get: \.contact.name, send: { .setName( $0 ) }))
                Button("Save") {
                    ViewStore.send(.saveButtonTapped)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        ViewStore.send(.cancelButtonTapped)
                    }
                }
            }
        }
    }
}
