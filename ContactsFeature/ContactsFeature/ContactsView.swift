
//
//  ContactsView.swift
//  ContactsView
//
//  Created by Yoshinori Kobayashi on 2023/10/02.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
    // ContactsFeatureのStoreを保持
    let store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack {
            // Storeを監視する
            WithViewStore(self.store, observe: \.contacts) { ViewStore in
                List {
                    ForEach(ViewStore.state) { contact in 
                        Text(contact.name)
                    }
                }
                .navigationTitle("Contacts")
                .toolbar {
                    ToolbarItem {
                        Button {
                            ViewStore.send(.addButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        // TCAには、SwiftUIのネイティブなナビゲーションツール
        // （シート、ポップオーバー、フルスクリーンカバー、アラート、確認ダイアログなど）
        // を模倣するさまざまなツールが付属している
        // バインディングの代わりにストアを使用します。
        //
        // sheet(store:) ビューモディファイアを使用して、addContact機能の
        // プレゼンテーションドメインのみにストアのスコープを絞り込みます。
        // addContact の状態がnilでなくなると、AddContactFeature ドメインのみに
        // 焦点を当てた新しいストアが派生し、それを AddContactView に渡すことができます。
        .sheet(
            store: self.store.scope(
                state: \.$addContact,
                action: { .addContact($0) }
            )
        ) { addContactStore in 
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
    }
}

#Preview {
    ContactsView(
        store: Store (initialState: ContactsFeature.State(
            contacts: [
                Contact(id: UUID(), name: "Blob"),
                Contact(id: UUID(), name: "Blob Jr"),
                Contact(id: UUID(), name: "Blob Sr"),
            ]
            )
        ) {
            ContactsFeature()
        }
    )
}
