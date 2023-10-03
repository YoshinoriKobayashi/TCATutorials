//
//  CounterFeatureTests.swift
//  CounterFeatureTests
//
//  Created by Yoshinori Kobayashi on 2023/10/02.
//

import XCTest
import ComposableArchitecture

// プロジェクトとテストはターゲットが異なるので参照できない
// https://dev.classmethod.jp/articles/how-to-start-ios-unit-test/
// 別ターゲットのコードを参照できるようにする必要がある。
// @testableを使用することで別ターゲットのコードを参照することが可能。
// 今回は、@testableがなくても動く
//@testable import TCA

// テストで使うSwiftファイルのTarget Membershipにチェックを入れてあげる
// 今回は、CounterFeature.swiftの[Target Membership]で、CounterFeatureTestsのTargetにチェックを入れる


final class CounterFeatureTests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // セットアップ・コードをここに置く。このメソッドは、クラス内の各テスト・メソッドを呼び出す前に呼び出されます。
//
//        // UIテストでは通常、失敗が発生したら即座に停止するのがベストである。
//        continueAfterFailure = false
//
//        // UI テストでは、テストを実行する前に、インターフェイスの向きなどの初期状態を設定することが重要です。setUp メソッドは、これを行うのによい場所です。
//    }
//
//    override func tearDownWithError() throws {
//        // ティアダウン・コードをここに置く。このメソッドは、クラス内の各テスト・メソッドが呼び出された後に呼び出されます。
//    }
//
//    func testExample() throws {
//        // UIテストは、テストするアプリケーションを起動しなければならない。
//        let app = XCUIApplication()
//        app.launch()
//
//        // XCTAssert および関連する関数を使用して、テストが正しい結果を生成することを検証してください。
//    }
//
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // アプリケーションの起動にかかる時間を測定します。
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
//    
    // カウンタ機能の非常に単純な増加動作と減少動作のテストを作成
    // @MainActorはメインスレッドで実行、デフォルトで非同期
    
    // TCAのテストツールは非同期で利用する
    @MainActor
    func testCounter() async {
        // TestStoreはStoreを作成するのと同じ方法で作成
        // Featureを開始するための初期値を提供する
        let store = TestStore(initialState: CounterFeature.State()) {
            // Reducerをクロージャで提供する
            CounterFeature()
        }
        
        // ユーザーの操作をエミュレートするために、StoreにActionを送ります
        // インクリメント・ボタン、デクリメント・ボタンのタップをエミュレートする。
        // TestStoreのsendメソッドが非同期なのは、ほとんどの機能が非同期のSideEffectを伴い、
        // TestStoreが非同期コンテキストを使って、それらのSideEffectを追跡するため
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
        
    }
}
