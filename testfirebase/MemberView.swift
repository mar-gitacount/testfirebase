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
    //@State var maintestview = MaintestView()
    
    @Binding var flgNo: Int
    //@Binding var checkid: String
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
    @State private var useremptycheck = Change_User_flg.shared.id

    @State private var test = "test"
    @AppStorage("isOnbord") var isOnbord: Bool = true
    @AppStorage("count_key") var counter = 0
    @State private var UsersignupModalShow:Bool = false
    @FocusState var focusstate:Bool
    //ここでログインフラグ判定ステート=toggleで変更監視している。
    /**ここをデフォでfalseを代入していると延々とビューがコントロールできない。 */
    @State private var user_flg : Bool = false
    //let usertest = Auth_user_get_data(name:"name")
    var body: some View {
        if(flgNo==2){
            VStack{
                //ユーザーストレージがあればtrue
                //falseにした場合、
                Text(self.useremptycheck)
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
                    .focused($focusstate)
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
                    .focused($focusstate)
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
                                //self.UsersignupModalShow.toggle()
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
                                            self.flgNo = 2
                                            //self.checkid="登録id"
                                            self.test = "test2"
                                            //change.id = self.testmain.rink
                                            //Change_User_flg.addValue()
                                            //self.email_error = change_user_flg.id
                                            /**userクラスをtrueにする。*/
                                            //user_flg.toggle()
//                                            NavigationLink(destination: UserView(),
//                                                           isActive: $user_flg) {
//                                                EmptyView()
//                                            }
                                            
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
                })//.sheet(isPresented:$UsersignupModalShow){UserSignupModalView(username: name , email: email,message: email_error)}
                //.alert(isPresented: $isShowAlert, content:{Alert(title: Text($alertMessage))}).padding().cornerRadius(60)
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
                    UserSignupModalView(username: name , email: email ,password:password, message: "")
                }
            }.toolbar {
                ToolbarItemGroup(placement: .keyboard){
                    Spacer()
                    Button("閉じる"){
                        focusstate = false
                    }
                }
            }
        }
    }
}
struct UserSignupModalView: View{
    //ここでユーザー登録があれば→登録があります!!こちらでログインしますか?と聞く
    //ログインビューから名前やemailの情報が渡されるので、それをテキストフィールドに入力する。
    //渡された値をテキストフィールドモデルに渡して入力。
    //テキストフィールドモデル判定はジャッジユーザークラスで判定させる。
    //Buttonactionでジャッジユーザークラスを呼び出す。
    //呼び出してジャッジユーザークラスはユーザーデータを精査してtrueならページ遷移。appstrageに情報を格納する。
    @State public var username:String = ""
    @State public var email:String = ""
    @State public var password:String = ""
    @FocusState var focusstate:Bool
    var message:String
    var texts = TextProtocolMakeValue(ItemArray: ["email","name"])
    //テキストフィールドの値
    //テキストフィールドの準拠プロトコル雛形作成関数。引数は文字列で受け取り、帰値は準拠プロトコル。
    //ユーザーが入力した値を第二引数に代入したい。
    var textvalue = [
        Textfieldprotcol(TextFieldtext: "email"),
        Textfieldprotcol(TextFieldtext: "name")
    ]
    var textfields = TextFieldClass()
//        ])
    var body: some View{
        VStack{
            TextField("メールアドレスを入力してください。",text:$email,onEditingChanged: {
                begin in
                /// 入力開始処理
                if begin {
                    //self.email_edittiig = true    // 編集フラグをオン
                    self.email = ""       // メッセージをクリア
                    /// 入力終了処理
                } else {
                    //self.email_edittiig = false   // 編集フラグをオフ
                }
            }).autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .focused($focusstate)
            SecureField("パスワードを入力してください。",text:$password).autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                .focused($focusstate)
            
            //textfields.view(textvalues: textvalue)
            Button(action:{
                if(self.email==""){
                    
                }else if(self.password==""){}
                else{
                    Auth.auth().createUser(withEmail:self.email,password:self.password){
                        authResult,error in
                        print(authResult)
                    }
                }
            },label:{
                Text("新規登録")
            })
        }.toolbar {
            ToolbarItemGroup(placement: .keyboard){
                Spacer()
                Button("閉じる"){
                    focusstate = false
                }
            }
        }
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

//-----------------------------------
//ここからテキストフィールドの大元を作るので完成次第不要なクラスなどは削除する。
class TextFieldClass {
    var email:String
    var name:String
    var textfieldcounts:Int
    //@Stateにして、即時関数にする?
    var textfieldvalues:[Textfieldprotcol]
    //static let shared = TextFieldClass()
    //ここをインスタンス時に設定できるようにする。
    init(){
        //self.textfieldcounts = 1
        //self.view()
        self.email = ""
        self.name = ""
        self.textfieldcounts = 1
        self.textfieldvalues = [Textfieldprotcol(TextFieldtext:"email")]
        
    }
    func view (textvalues:[Textfieldprotcol])->TextfieldModel{
        return TextfieldModel(texts:textvalues)

    }
    //引数は配列で受け取る。
    func textviewreturn(textvalueArray:[String])->TextfieldModel{
        let textvalueArrayChangeIsTextFiledprotocolvalue:[Textfieldprotcol]
        let texttest = "テスト"
        textvalueArrayChangeIsTextFiledprotocolvalue = [Textfieldprotcol(TextFieldtext:texttest)]
        return TextfieldModel(texts:textvalueArrayChangeIsTextFiledprotocolvalue)
    }
//    init(){
//        self.email = email
//        self.name = name
//    }
}
//func textreturn()->TextFieldClass{
//    return TextFieldClass()
//}

//テキストフィールドの準拠プロトコルを用意する。
//ここでルール化する。
struct Textfieldprotcol: Identifiable{
    let id = UUID()
    let TextFieldtext:String
    //let TextFieldValue:String
//    do {
//        try  let TextFieldValue:String
//    } catch {
//        TextFieldtext = ""
//    }
    //let TextFieldArray:[String]
}

//Idenfifiablearryappendテスト
//テスト後消去する。
struct textarray: Identifiable{
    let id = UUID()
    let array:[String:String]
}

struct testarrayModal: View{
    //var testarrayvalue:[textarray(array:["t","t"])]
    
    let apple = "apple"
    var body: some View{
        Text("テストArray!!")
        
    }
}
//呼び出し元の値によってテキストフィールドの表示が変わる。
struct TextfieldModel: View{
    var texts:[Textfieldprotcol]
    //var usertext:[String]
    //Foreachで準拠プロトコルをループさせ、その中の連想配列を呼び出す。
    @State var text = ""
    @State private var textfieldindex:Int = 1
    @State private var UserInputtextArray = ["test","test2"]
    //self.UserInputtextArray.append("ichikawa")
    //UserInputtextArray.append(contentsOf : ["w"])
    var body: some View{
        //TextField(self.boxmessage, text:self.$text)
        //textsの長さだけfor文を回す。
        //Text(UserInputtextArray[1])
        //Spacer()
        ForEach(UserInputtextArray, id: \.self) { item in
                        Text(item)
                            .padding()
                    }
        ForEach(texts) {t in
            //配列が存在しない時のためにエラーハンドリングする。
            TextField(t.TextFieldtext,text:$UserInputtextArray[0])
           
        }
//        Button(action:{
//        })
    }
}

func TextvalueChenck(TexfFieldCheck:[Textfieldprotcol]){
    
}
//この関数を呼び出すだけで、テキストフィールドに必要なアイテムが帰ってくる。
func TextProtocolMakeValue(ItemArray:[String])->[Textfieldprotcol]{
    let text = [Textfieldprotcol(TextFieldtext:"email")]
    let Items:[Textfieldprotcol]
    //Items.append([Textfieldprotcol(TextFieldtext:"t")])
    return text
}

func signincheck(){
    
}
//-----------------------------------
