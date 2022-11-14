//
//  ScreenTransitionView.swift
//  testfirebase
//
//  Created by 市川マサル on 2022/10/16.
//

import Foundation
import SwiftUI
import FirebaseDatabase
import FirebaseAuth
import UIKit

//Published=@Stateに近い機能。クラス内のプロパティを管理する。

class Model: ObservableObject {
    //ここを振り分けてページ出し分ける。本番アプリでは、ちゃんとコードを書き分ける
    //ここでDBデータを受け取り、ニュースに渡す。
    @Published var MemberViewPushed = false
    //@Published var ref = Database.database().reference()
    //@Published var message  = "から"
    @Published private(set) var message:String = "関数前"
    @Published private(set) var message_prev:String = "プレビュー"
    /** 空にするとエラーになる。*/
    @Published private(set) var req_colection = "message"
    /**引数にてchildを渡すような形,引数要引数*/
    /**この関数はあくまでも単体のレコードを渡すクラスメソッドなので複雑な条件の場合は他のメソッドで規定する。 */
    /**https://qiita.com/chocoyama/items/a588c3569b8dd89cd223 */
    /**以下変数でレコードネームを規定して、文字として呼び出し元に返す。 */
    func get_record(){
        let ref = Database.database().reference()
        /**以下引数に渡す値が空の場合、エラーが吐き出される。 */
        ref.child(req_colection).getData{(error, snapshot)in
            if error != nil {
                self.message = "エラー"
            }
            else if let snapshot = snapshot {
                if snapshot.exists(){
                    guard let message = snapshot.value as? String else{
                        self.message = "空?"
                        return
                    }
                    self.message = message
                }
            }
            
            return
        }
        self.message = message
    }
}

/**ユーザーオブジェクトを返す所 */
class UserModel:ObservableObject {
    @Published var MemberViewPushed = false
    @State private var signInWithAppleObject = SignInWithAppleObject()
}
