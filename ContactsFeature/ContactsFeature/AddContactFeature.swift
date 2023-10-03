//
//  AddContactFeature.swift
//  ContactsFeature
//
//  Created by Yoshinori Kobayashi on 2023/10/02.
//

import ComposableArchitecture
import SwiftUI


// 新しい連絡先の名前を入力する機能のReducerとViewを保持する
struct AddContactFeature: Reducer {
    struct State: Equatable {
        var contact: Contact
    }
    enum Action: Equatable {
        case cancelButtonTapped
        case saveButtonTapped
        case setName(String)
    }
    
    // この機能には、"Cancel "ボタンと "Save "ボタンがあります。
    // "Cancel "ボタンをタップすると、この機能が解除され、連絡先が親の連絡先リストに追加されます。
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .cancelButtonTapped:
            return .none
        case .saveButtonTapped:
            return .none
        case let .setName(name): 
            state.contact.name = name 
            return .none
        }
    }
}

#Preview {
    NavigationStack {
        // AddContactFeatureのStoreを保持し、コンタクト名のテキストフィールドと送信アクションを表示するために状態を監視するビューを追加します。
        AddContactView(store: Store(initialState: AddContactFeature.State(contact: Contact(id: UUID(), name: "Blob")), reducer: { 
            AddContactFeature()
        }))
    }
}
