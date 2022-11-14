//
//  MainView.swift
//  testfirebase
//
//  Created by 市川マサル on 2022/10/29.
//

import SwiftUI
struct ListArray: Identifiable {
    let id: Int
    let name: String
    let img:String
    var test:View_Standard = View_Standard()
}


/**トピックス補完の構造体 */
struct View_Standard{
    var main_text_array:[String] = ["ホーム","探す","通知"]
}

class View_Standard_Text{
    private init(){}
    /**自身を静的変数に入れて、固定化する。 自分のクラス内に自分を入れていてわかりづらい*/
    static let shared = View_Standard_Text()
    let main_text_array:[ListArray] = [
        ListArray(id:1,name:"ホーム",img:"message.fill"),
        ListArray(id:2,name:"探す",img: "magnifyingglass"),
        ListArray(id:3,name:"通知",img:"face.smiling.fill")
    ]
    
//    init(main_text_array:[ListArray]){
//        self.main_text_array = main_text_array
//    }
}

/**規定した構造体が返り値になる。 */
func List_text_back() -> [ListArray] {
    let share = View_Standard_Text.shared
//    let share_array = share.main_text_array
//    var share_matrix:[ListArray] = []
//    ForEach(share_array){share_array in
//        share_matrix.append(share_array)
//    }
    return share.main_text_array
}

struct MainView: View {
    @State private var ViewStandard = View_Standard()
    @State private var Textarray = View_Standard.init(main_text_array:)
    /**ここを関数にする。 */
    @State private var Viewcontroll = MemberView()
    @State private var selectedTag = 1
    var body: some View {
        /**リスト一覧 */
        //let list = List_text_back()
        //Viewcontroll
        //self.Viewcontroll = Mainview_animaiton()
//        TabView(selection:$selectedTag){
//        ForEach(list) { list in
//                Viewcontroll.tabItem{
//                    Image(systemName: list.img)
//                    Text(list.name)
//                }.tag(list.id)
//            }
//        }.accentColor(.green)
        /**関数を呼ぶ */
        TabView(selection:$selectedTag){
            Viewcontroll
                        .tabItem {
                            Image(systemName: "message.fill")
                            Text("メッセージ")
                        }.tag(1)
            Viewcontroll
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("さがす")
                        }.tag(2)
                    UserCheck()
                        .tabItem {
                            Image(systemName: "face.smiling.fill")
                            Text("スタンプ")
                        }
                }
                .accentColor(.green) //ここで色の指定
    }
}

struct Mainview_animaiton: View{
    var body: some View {
        Text("")
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
