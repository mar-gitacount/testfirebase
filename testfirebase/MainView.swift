//
//  MainView.swift
//  testfirebase
//
//  Created by 市川マサル on 2022/10/29.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import LocalAuthentication
struct ListArray: Identifiable {
    let id: Int
    let name: String
    let img:String
    var test:View_Standard = View_Standard()
}

struct MaintestView: View {
    /**ログインに成功したら、配列を空にして成功したコードの中で再度配列を入れ込む */
    @State var subViewItems: [SubtestViewItem] = []
    @State var selectiontag = 1
    @State var flgNo = 1
    
    
//    self.subViewItems.append(SubtestViewItem())
    init() {
           UITabBar.appearance().isHidden = false
        
       }
    
    var body: some View {
        VStack {
            /**ここで呼び出しビューの設定をする。 */
            if(flgNo==2){
                let Viewc = UserView()
                TabView(selection:$selectiontag){
                    UserView().tabItem{
                        Image(systemName: "message.fill")
                    }.tag(1)
                }
            }else{
                TabView(selection:$selectiontag){
                    UserCheck(flgNo:$flgNo).tabItem{
                        Image(systemName: "face.smiling.fill")
                    }.tag(2)
                }
            }
                NavigationView{
                    Button("ADD", action: {
                        /**押すたびにviewを描画する。 */
                        self.flgNo = 1
//                        if(subViewItems.isEmpty){
//                            self.subViewItems.append(SubtestViewItem())
//                        }
                    })
                }
//            ForEach(subViewItems) { item in
//                SubView(item: item)
//            }
//            TabView(selection:$selectiontag){
//                UserView()
//                    .tabItem {
//                        Image(systemName: "message.fill")
//                        Text("メッセージ")
//                    }.tag(1)
//                UserView()
//                    .tabItem {
//                        Image(systemName: "message.fill")
//                        Text("メッセージ")
//                    }.tag(2)
//            }.onChange(of:selectiontag){
//                selection in
//                if(selection == 2){
//                    //self.subViewItems.append(SubtestViewItem())
//                    //UserView().removeFromSuperview()
//                }
//
//            }
//            ForEach(0..<subViewItems.count, id: \.self) { index in
//                SubView(item: subViewItems[index])
//            }
        }

    }
}

struct SubtestViewItem: Identifiable {
    let id = UUID()

}

struct SubView: View {
    let item: SubtestViewItem
    
    var body: some View {
            UserView()
    }
}




/**ここのクラスを監視してpublishedを制御する */
//class Change_User_Flg:ObservableObject{
//    @Published var UserViewChangeFlg :Bool
//    @Published var test :Bool
//    /**ユーザーフラグを初期化する */
//    init(UserViewChangeFlg:Bool){
//        self.UserViewChangeFlg = false
//        self.test = true
//    }
//}
final class Tab_Insert{
    private init () {}
    static var shard = Tab_Insert()
//    var usertab: = UserView()
//    init(usertab:NSObject){
//        self.usertab = usertab
//    }

}
final class Change_User_flg{
    /**ここでユーザーデータを格納して、ビューの呼び出し先では、ユーザーnameの有無を判定する。*/
    // イニシャライズ
    private init() {}
    /**UserCheckでもここを参照してログインが成功すれば、ここに格納する。 */
    static var shared = Change_User_flg()
    var tabViewChange = Tab_View_change()
    var changePage = Userpage()
    // ユーザID=Appstorage
      var id: String = ""
      // ユーザ名=Appstorage
      var name: String = ""
    init(id:String,name:String){
        self.id = id
        self.name = name
    }
    func addValue(){
        self.tabViewChange.id = id
    }
    func changedUserpage(){
        self.changePage.flg = true
    }
      // ユーザ情報セットメソッド
//      public static func setChange_User_flg(id: String, name: String) {
//          self.id = id
//          self.name = name
//      }
    
}

struct Tab_View_change{
    var id:String = "test"
    
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
func TabControll() -> TabViewseCotroll{
//    let share = Change_User_flg.shared.self.flg
    //var name: String
    let change_user_flg = Change_User_flg.init(id: "testid", name: "testname")
    return TabViewseCotroll()
}


/**このクラス内の変数を制御して、MainViewで関数を呼び出すたびに以下の構造体のTabViewが切り替わるようにする。
その為にはユーザーログインに成功するたびに、フラグを切り替える。 */
/**呼び出される度にEmptyViewすれば、タブビューの被りはないかも、、 */
struct TabViewseCotroll: View{
    @State var selectionTag = 1
    //@ObservedObject var viewModel = Change_User_Flg(UserViewChangeFlg:true)
    //@State var test = viewModel.UserViewChangeFlg
//    viewModel.UserViewChangeFlg = true
//    if (userflgclass){
//        print("")
//    }
    var body: some View{
        return TabView(selection:$selectionTag){
            
        }
    }
}
func usercheck()->Bool{
    /**この関数でアップルログインか通常ログインかを選別する。
     なぜなら、アップルログインか通常ログインかでも選別する方法が異なるため*/
    var usercheck = Change_User_flg.shared.id
    /**ここでユーザー判定 */
    if usercheck != ""{
        return true
    }
    return false
    
}

struct AnyviewItew:Identifiable{
    let id = UUID()
}

struct testAnyView: View {
    @State private var selectiontabindex = 0
    //var testanyview:AnyView
    let views:[AnyviewItew] = []
    @State var flgNo = 1
    var body: some View{

        VStack{
//            Spacer()
//            showView()
//            Spacer()
            TabView(selection:$selectiontabindex){
                ForEach(0..<self.views.count){ index in
                    showView().tabItem{
                        Image(systemName: "magnifyingglass")
                        //Text(self.views[index])
                    }.tag(index)
                }
            } .accentColor(.green)
        }
    }
    private func showView() -> AnyView{
        switch self.selectiontabindex{
        case 1:
//            usercheck() == true ? return AnyView(Userpage()):return AnyView(UserCheck())
            if(usercheck()){
                return AnyView(Userpage())
            }else {
                return AnyView(UserCheck(flgNo:$flgNo))
            }

        default:
            return AnyView(MemberView())
        }
    }
}
/**レンダリングして毎回関数を呼び出す動き */
/**レンダリングするにはstructを引き継いで、参照先の構造体をクラスが更新する。 */
struct MainView: View {
    static var kazu = 1
    @State private var ViewStandard = View_Standard()
    @State private var Textarray = View_Standard.init(main_text_array:)
    @State private var userviewflg = false
   
    var rink = "メインのプロパティ"
    /**管理下する事でタブを動的に切り替えるようにする。
     呼び出し先でフラグを判定し、タブの内容を切り替える。
     */
    //@State private var TabChangeBar = TabControll()
    /**切り替えフラグを監視下に置き、切り替える度にTabChangeBarが動的に機能するようにする。切り替えフラグは共通インスタンス */
//    @StateObject private var test  = Change_User_flg()
    @State private var Viewcontroll = MemberView()
    @State private var selectedTag = 1
    @State var flgNo = 1
    @State var userflg:Bool = false
    @State var checkid = Change_User_flg.shared.id

    /**以下はidフラグ */
    @State private var change_user_flg = Change_User_flg.shared.id
    @State private var changetab = Change_User_flg.shared
    //@State private var Usercheck  = UserCheck(flgNo:$flgNo)
//    @State private var tab = Tab_Insert.shard.usertab
    var test = "テスト"
  
    //@ObservedObject var viewModel = Change_User_Flg(UserViewChangeFlg:true)
    //@State private var view = viewModel.(UserViewChangeFlg:true)
    var body: some View {
        
//        if(checkid){
//            userflg = true
//        }
        
        //self.id == "" ? self.flgNo = 2 : self.flgNo = 1
        //testAnyView()
        //MaintestView()
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
        /**ここでTabview切り替え */
        /**以下を関数化する。 */
        /**TabChangeBarをセットする。 */
        /**publicな関数を直接参照しにいくか。 */
        if(userviewflg){
            TabViewseCotroll()
            /**参照型usercheckに対して直接userpageを代入する。*/
        }
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
                UserCheck(flgNo:$flgNo)
                    .tabItem {
                        Image(systemName: "face.smiling.fill")
                        Text(test)
                    }.tag(3)
            }
            .accentColor(.green).onChange(of:selectedTag){
                selection in
                if selection == 3{
                    changetab.changedUserpage()
                    usercheck() == true ?  print("ユーザーページ"):print("ユーザーチェックページ")
                    changetab.addValue()
                    // test = Change_User_flg.shared.id
                    
                }
            }//ここで色の指定
    }
}

struct Mainview_animaiton: View{
    var body: some View {
        Text("")
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(Model())
    }
}
