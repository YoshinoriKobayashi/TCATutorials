//
//  ContactsFeature.swift
//  ContactsFeature
//
//  Created by Yoshinori Kobayashi on 2023/10/02.
//

import ComposableArchitecture
import SwiftUI

struct Contact: Equatable, Identifiable {
    let id: UUID
    var name: String
}

// このファイルで連絡先機能の基本を取得
struct ContactsFeature: Reducer {
    // あとでテストするためにEquatableに適合
    struct State: Equatable {
        // オプションの値を保持するためにPresentationStateプロパティラッパーを使用して、機能の状態を統合します。
        // nil値は「連絡先追加」機能が提示されていないことを表し、non-nil値は提示されていることを表す。
        @PresentationState var addContact: AddContactFeature.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    // あとでテストするためにEquatableに適合
    enum Action: Equatable {
        case addButtonTapped  // +ボタンタップ
        case addContact(PresentationAction<AddContactFeature.Action>) 
    
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in 
            switch action {
            case .addButtonTapped:
                // これだけで、2つの機能のドメインを統合することができます。
                // ビューに移る前に、このライブラリが提供する機能を活用し始めることができます。
                // 2つの機能が非常に密接に統合されているので、
                // 今では「連絡先を追加」の機能の表示と非表示を簡単に実装できます
                state.addContact = AddContactFeature.State(contact: Contact(id: UUID(), name: ""))
                return .none
            
                
            case .addContact(.presented(.cancelButtonTapped)):
                // "Add Contact"（連絡先を追加）機能内のアクションを監視するため、
                // PresentationAction.presented(_:)のケースでデストラクチャリングを行っています。
                // デストラクチャリングは、構造体やタプルの要素を変数や定数に分解する手法を指します。

                // 連絡先リストの「+」ボタンがタップされたとき、addContactの状態を更新して、
                // その機能が表示されるべきことを示すことができます。
                state.addContact = nil
                return .none
            
            case .addContact(.presented(.saveButtonTapped)):
                // "Add Contacts"（連絡先を追加）機能内で「Save」（保存）ボタンがタップされた場合、
                // その機能を閉じるだけでなく、新しい連絡先をContactsFeature.Stateに
                // 保持されている連絡先のコレクションに追加したいと思います。
                guard let contact = state.addContact?.contact
                else { return .none }
                state.contacts.append(contact)
                state.addContact = nil
                return .none

                // これだけで、親機能と子機能の間の通信を実装することができます
                // 。親機能は、ナビゲーションを駆動するための状態を作成することができ、
                // 親機能は子のアクションを監視して、上に重ねたい追加のロジックを
                // どのように実行するかを判断することができます。
            case .addContact:
                //PresentationActionを保持するケースを追加して、機能のアクションを統合。
                return .none
            }
        }
        // ifLetでReducerを統合できる
        // これは、子アクションがシステムに入ってきたときに子リデューサーを実行し、
        // すべてのアクションで親リデューサーを実行する新しいリデューサーを作成します。
        // また、子機能が却下されたときのエフェクトのキャンセルや、
        // その他多くのことを自動的に処理します
        .ifLet(\.$addContact, action: /Action.addContact) {
            AddContactFeature()
        }
    }
}
