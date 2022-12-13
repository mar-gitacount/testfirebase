//
//  MemberView.swift
//  testfirebase
//
//  Created by 市川マサル on 2022/10/16.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import LocalAuthentication


struct MemberView: View {
    /**外部firebaseと接続クラスのインスタンス */
    @ObservedObject var viewModel = Model()

    //@State var test = self.viewModel.ref_Simple_get()
    @State var selectedTag = 1
    var body: some View {
        /**ここでログイン非ログインを切り分けする。 */
        HomeTabView()
//        TabView(selection: $selectedTag){
//            HomeTabView()
//                .tabItem  {
//                        Image(systemName: "house")
//                        Text("ホーム")
//                }.tag(1)
//            NewsTabView()
//                .tabItem {
//                    Image(systemName: "news")
//                    Text("ニュース")
//                }.tag(2)
//            MakeView().tabItem{
//                Image(systemName: "news")
//            }.tag(3)
//        }
    }
}
/**ホームのメインビュー */
struct HomeTabView: View{
    @ObservedObject var viewModel = Model()
    var body: some View{
        VStack {
            Image(systemName: "music.note.house")
                .scaleEffect(x:3.0,y:3.0)
                .frame(width:100,height: 100)
            Text(viewModel.message).font(.system(size: 20))
            Button(action: {
                self.viewModel.get_record()
            }){
                Text("ボタン")
            }
               
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.5, green:0.9, blue:0.9))
       
    }
}
struct UserView: View{
    @State var maintestview = MaintestView()

    var body: some View {
        return
        VStack{
            Text("ユーザーページ!!")
            Button("empty",action: {
                self.maintestview.subViewItems.removeAll()
            })
        }
       
    }
}
struct Userpage :View{
    @State var flg:Bool = false
    var body: some View {
        if(self.flg){
            UserView()
        }else{
            UserView()
        }
    }
}
/**新規登録画面 */
/**UserCheck画面からモーダル表示する。UserCheck内にモーダルボタン設置する。 */
/**ユーザーチェックしてtrueならユーザーページに遷移する。ー */
/**通常ログインとアップルログインで処理を分ける。 */
struct UserCheck :View {
    let context = LAContext()
    //@State private var testmain = MainView()
    @State var maintestview = MaintestView()
    @Binding var flgNo: Int
    @ObservedObject var viewModel = Model()
    @State private var signInWithAppleObject = SignInWithAppleObject()
    @State private var email: String = "ichikawa.contact@gmail.com"
    @State private var email_error: String = ""
    @State private var password: String = "masa1205"
    @State private var password_error: String = ""
    @State private var alertMessage:String = ""
    @State private var isShowAlert = false
    @State private var name = ""
    @State private var message = ""
    @State private var editting = false
    @State private var email_edittiig = false
    @State private var password_editting = false
    /**以下でタブビューをコントロールできるか検証 */
    @State private var change = Change_User_flg.shared
    //@State private var id = change.id

    @State private var test = "test"
    @AppStorage("isOnbord") var isOnbord: Bool = true
    @AppStorage("count_key") var counter = 0
    @State private var UsersignupModalShow:Bool = false
    //ここでログインフラグ判定ステート=toggleで変更監視している。
    /**ここをデフォでfalseを代入していると延々とビューがコントロールできない。 */
    @State private var user_flg : Bool = false
    //let usertest = Auth_user_get_data(name:"name")
    var body: some View {
        if(flgNo == 2){
            VStack{
                Text("テストユーザー")
                Button("ログアウト",action:{
                    self.flgNo = 1
                })
            }
        }
        else{
            VStack {
                
                Text(test)
                //入力文字大文字を設定しない。
                Text(email_error).foregroundColor(Color.red)
                TextField("E-mail", text: self.$email,onEditingChanged: {
                    begin in
                    /// 入力開始処理
                    if begin {
                        self.email_edittiig = true    // 編集フラグをオン
                        self.email = ""       // メッセージをクリア
                        /// 入力終了処理
                    } else {
                        self.email_edittiig = false   // 編集フラグをオフ
                    }
                }).autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle()) // 入力域を枠で囲む
                    .padding()// 余白を追加
                // 編集フラグがONの時に枠に影を付ける
                    .shadow(color: email_edittiig ? .blue : .clear, radius: 3)
                Text(password_error).foregroundColor(Color.red)
                TextField("Password", text: self.$password,onEditingChanged: { begin in
                    /// 入力開始処理
                    if begin {
                        self.password_editting = true    // 編集フラグをオン
                        self.password = ""       // メッセージをクリア
                        /// 入力終了処理
                    } else {
                        self.password_editting = false   // 編集フラグをオフ
                    }
                }).keyboardType(.default).autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle()).padding() .shadow(color: password_editting ? .blue : .clear, radius: 3)
                //ログイン方法はアップルログインと、通常のログインを実装する。
                //falseが帰ってきた場合、登録画面にリダイレクトする。
                //入力値を制御す
                Button(action: {
                    //userのAuth
                    self.email_error = ""
                    self.password_error = ""
                    if(self.email == ""){
                        //ここでfalseを返す
                        self.email_error = "メールアドレスを入力してください。"
                    }else if(self.password == ""){
                        self.password_error = "パスワードを入力してください。 "
                    }else if (user_flg){
                        //Userview()
                    }
                    else{
                        //ここでサインイン設定。trueなら画面遷移して、会員のページにいく。
                        Auth.auth().signIn(withEmail:email,password: password) { (resurt,error) in
                            //認証で何かしらのエラーで実行される条件
                            if error != nil{
                                //エラーコードの変数を設定する。
                                //ここで登録画面打診メッセージを表示する。
                                self.email_error = "登録がありません"
                                //let errorCode = AuthErrorCode(rawValue: error.code)
                                //self.alertMessage = error?.localizedDescription ?? ""
                                self.alertMessage = "Error"
                                self.isShowAlert = true
                                
                            }else{
                                //認証が成功した時の処理を書く
                                //ログイン成功したら、それにひもづくデータを返す
                                //会員ページに画面遷移する。
                                //self.email_error = user.email
                                //画面遷移する。
                                let user = Auth.auth().currentUser
                                let ref = Database.database().reference()
                                //                            let alovelaceDocumentRef = ref.child("users").child("1AzjIctS3DOvIZHOHkmmfcCIXGi1").child(name)
                                //1AzjIctS3DOvIZHOHkmmfcCIXGi1
                                //成功したら画面を遷移してユーザーページを表示する。
                                if let user = user {
                                    let uids = user.uid
                                    let _ = print(uids)
                                    let email = user.email
                                    let db = Firestore.firestore()
                                    //firestoreでuserコレクション内のドキュメントを取得する。
                                    let userget = db.collection("users").document(uids)
                                    userget.getDocument { (document,error) in
                                        if let document = document, document.exists{
                                            let dataDesciption = document.data().map(String.init(describing:)) ?? "nil"
                                            self.email_error = "あるよ"
                                            change.addValue()
                                            change.id = "id"
                                            self.flgNo=2
                                            self.test = "test2"
                                            //change.id = self.testmain.rink
                                            //Change_User_flg.addValue()
                                            //self.email_error = change_user_flg.id
                                            /**userクラスをtrueにする。*/
                                            //user_flg.toggle()
                                            NavigationLink(destination: UserView(),
                                                           isActive: $user_flg) {
                                                EmptyView()
                                            }
                                            
                                            //user_flg.toggle()
                                        } else {
                                            self.email_error = "ないよ"
                                        }
                                    }
                                    // self.email_error = self.email
                                }
                                //ここで画面を遷移する。
                                self.alertMessage = "Success"
                                self.isShowAlert = true
                            }
                        }
                    }
                }, label: {
                    /**明日はここから */
                    //let userID = Auth.auth().currentUser!.uid
                    
                    Text("会員さんはこちらから").font(.body).frame(width:350,height: 50).background(Color.black)
                    //isPresented=他の画面から呼ばれた場合の処理。
                })//.alert(isPresented: $isShowAlert, content:{Alert(title: Text($alertMessage))}).padding().cornerRadius(60)
                .accentColor(Color.white)
                Button(action: {
                    signInWithAppleObject.signInWithApple()
                    /**Appストレージに入れ込む */
                    let userID = Auth.auth().currentUser!.uid
                    print(userID)
                    //self.name = userID
                    //print(signInWithAppleObject.signInWithApple())
                    //print("ここに表示される。")
                    // signInWithAppleObject.authorizationController()
                }, label: {
                    SignInWithAppleButton()
                        .frame(height: 50)
                        .cornerRadius(16)
                })
                .padding()
                Button(action: {
                    self.UsersignupModalShow.toggle()
                }){
                    Text("会員登録の方はこちら")
                }.sheet(isPresented: $UsersignupModalShow){
                    UserSignupModalView()
                }
            }
        }
    }
}
struct UserSignupModalView: View{
    var body: some View{
        Text("ユーザー情報を入力ください。")
    }
}
/**ニュースのメインビュー */
struct NewsTabView: View{
    var body: some View{
        Text("ニュース")
    }
}

/**試作するメインビュー */
struct MakeView: View{
    var body: some View{
        Text("モデル")
    }
}
struct MemberView_Previews: PreviewProvider {
    static var previews: some View {
        MemberView().environmentObject(Model())
    }
}
