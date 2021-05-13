//
//  ContentView.swift
//  WhoFirst
//
//  Created by Артем on 12.05.2021.
//

import SwiftUI

struct ContentView: View {
    let buttonColor = Color(red: 77.0/255.0, green: 97.0/255.0, blue: 252.0/255.0, opacity: 1.0)
    let lightGreyColor = Color(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, opacity: 1.0)
    
    @State var user: User? = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.userKey).flatMap { User(data: $0)} ?? nil
    @State var needLogin = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.userKey) == nil
    
    var body: some View {
        NavigationView {
            if(user == nil) {
                VStack(alignment: .center) {
                    Image("StartImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                        .padding(.bottom, 20)
                    
                    Text("Please, login")
                        .fontWeight(.medium)
                        .font(.largeTitle)
                        .padding(.bottom, 20)
                    
                    Button(action: {
                        needLogin = true
                    }, label: {
                        Text("Login").font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(buttonColor)
                            .cornerRadius(15.0)
                    })
                    
                }.padding()
                .navigationBarItems(
                    trailing: Button(action: {}) {Text("Logout").foregroundColor(lightGreyColor)}.disabled(true)
                )
            } else {
                ChallengeStatusView()
                    .navigationBarItems(
                        trailing: Button(action: {
                            self.user = nil
                            UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.userKey)
                        }) {Text("Logout").foregroundColor(buttonColor)}.disabled(false)
                    )
            }
        }.sheet(isPresented: $needLogin) {
            LoginView(isActive: $needLogin, user: $user)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
