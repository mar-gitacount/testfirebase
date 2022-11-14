//
//  ContentView.swift
//  testfirebase
//
//  Created by 市川マサル on 2022/10/10.
//
//ここで投稿一覧を表示させる
//DB負荷軽減のため、制限ローカルで情報を保存し、分岐させる。
import SwiftUI
import FirebaseDatabase
//会員ページ
//struct MemberView: View{
//    var body: some View {
//        VStack {
//            Text("会員ページ")
//
//        }
//
//    }
//}

struct ContentView: View {
    @State var message = ""
    @State var button  = "ボタン"
    @State private var isShowingView: Bool = false
    @State private var Viewcontroll = MemberView()
    //ページ切り替えクラス
    @EnvironmentObject var model: Model
    var body: some View {
        Viewcontroll
        VStack {
            VStack {
                Text(message).padding().onAppear{
                    let ref = Database.database().reference()
                    ref.child("message").getData {(error, snapshot)in
                        if let error = error {
                            print("Error getting data \(error)")
                            self.message = "test"
                            return
                        }
                        else if let snapshot = snapshot {
                            if snapshot.exists(){
                                guard let message = snapshot.value as? String else{
                                    self.message = "test"
                                    return
                                }
                                self.message = message
                            }
                        }
                        self.message = message
                    }
                }
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!!!")
            }.frame(maxHeight:.infinity)
            HStack{
                //ここを押下する事で、画面を遷移する。
                if(isShowingView){
//                    self.model.MemberViewPushed　= true
                    //Text("\(model.teststring)")
                    
                    MemberView()
                }else{
                    Text("フッター")
                    Button(action: {
                        button = "ボタンタップ"
                        isShowingView.toggle()
                    }){
                        //ContentView_Previews.seigyo = false
    //                    isShowingView = true
                        Text(button)
                    }.fullScreenCover(isPresented: $isShowingView, content: {
                        MemberView()
                    })
                    NavigationView{
                        NavigationLink(destination:MemberView()){
                            Text("画面移動")
                        }
                    }
                }
            }
//            NavigationView{
//                NavigationLink(destination: MemberView()){
//                    Text("遷移する")
//                }
//            }
        }.frame(maxHeight:.infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
//    static var seigyo :Bool = true
    static var previews: some View {
        ContentView().environmentObject(Model())
    }
}
