//
//  ContentView.swift
//  WhoFirst
//
//  Created by Артем on 12.05.2021.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    let buttonColor = Color(red: 77.0/255.0, green: 97.0/255.0, blue: 252.0/255.0, opacity: 1.0)
    let lightGreyColor = Color(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, opacity: 1.0)
    
    @State var user: User? = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.userKey).flatMap { User(data: $0)} ?? nil
    @State var needLogin = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.userKey) == nil
    
    var body: some View {
        NavigationView {
            if(user == nil) {
                VStack(alignment: .center) {
                    Image("UnicornVine")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                        .padding(.bottom, 20)
                    
                    Text("Пожалуйста, авторизуйтесь")
                        .fontWeight(.medium)
                        .font(.largeTitle)
                        .padding(.bottom, 20)
                    
                    Button(action: {
                        needLogin = true
                    }, label: {
                        Text("Вход").font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(buttonColor)
                            .cornerRadius(15.0)
                    })
                    
                }.padding()
                .navigationBarItems(
                    trailing: Button(action: {}) {Text("Выход").foregroundColor(lightGreyColor)}.disabled(true)
                )
            } else {
                ChallengeStatusView()
                    .navigationBarItems(
                        trailing: AlertButtonExit(user: $user)
                            .disabled(false)
                    )
            }
        }.sheet(isPresented: $needLogin, onDismiss: {
            if(self.user == nil) {
                self.user = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.userKey).flatMap { User(data: $0)} ?? nil
            }
        }) {
            LoginView(isActive: $needLogin, user: $user)
        }
    }
}

struct AlertButtonExit: View {
    @Binding var user: User?
    @State var isPresented = false
    let buttonColor = Color(red: 77.0/255.0, green: 97.0/255.0, blue: 252.0/255.0, opacity: 1.0)
    
    
    var body: some View {
        Button(action: {
            self.isPresented = true
        }) {Text("Выход").foregroundColor(buttonColor)}
        .alert(isPresented: self.$isPresented){
            Alert(title: Text("Выйти из профиля?"),
                  primaryButton: .destructive(Text("Ок")) {
                    self.user = nil
                    UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.userKey)
                    do { try Auth.auth().signOut() }
                    catch { print("already logged out") }
                  },
                  secondaryButton: .cancel(Text("Отмена"))
            )}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
