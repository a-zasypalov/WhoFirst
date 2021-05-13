//
//  LoginView.swift
//  WhoFirst
//
//  Created by Артем on 13.05.2021.
//

import SwiftUI
import Firebase
import SwiftUIX

struct LoginView: View {
    @Binding var isActive: Bool
    @Binding var user: User?
    
    @State private var login = ""
    @State private var password = ""
    
    @ObservedObject private var viewModel = LoginViewModel()
    
    @Environment(\.colorScheme) var colorScheme
    
    let lightGreyColor = Color(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, opacity: 1.0)
    let darkGreyColor =  Color(red: 15/255.0, green: 15/255.0, blue: 15/255.0, opacity: 1.0)
    let loginButtonColor = Color(red: 77.0/255.0, green: 97.0/255.0, blue: 252.0/255.0, opacity: 1.0)
    
    @Namespace var loginNamespace
    
    var body: some View {
        if(viewModel.user == nil) {
            ScrollView {
                VStack {
                    Text("Who First?")
                        .fontWeight(.semibold)
                        .padding([.top, .bottom], 20)
                        .font(.largeTitle)
                    
                    Image("StartImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .center, spacing: 20){
                        TextField("Login", text: self.$login)
                            .padding()
                            .background(colorScheme == .light ? lightGreyColor : darkGreyColor)
                            .cornerRadius(5)
                            .padding(.bottom, 15)
                        
                        SecureField("Password", text: self.$password)
                            .padding()
                            .background(colorScheme == .light ? lightGreyColor : darkGreyColor)
                            .cornerRadius(5)
                            .padding(.bottom, 15)
                        
                        Button(action: {
                            viewModel.authorize(login: self.login, pass: self.password)
                        }, label: {
                            Text("Login").font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 220, height: 60)
                                .background(loginButtonColor)
                                .cornerRadius(15.0)
                        })
                        
                    }.padding()
                }
            }
        } else {
            VStack(alignment: .center, spacing: 20){
                Text("Login successful!")
                    .fontWeight(.medium)
                    .padding([.top, .bottom], 20)
                    .font(.largeTitle)
                
                Image("UnicornOk")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 20)
                
                Button(action: {
                    self.user = viewModel.user
                    self.isActive.toggle()
                }, label: {
                    Text("Go to app").font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(loginButtonColor)
                        .cornerRadius(15.0)
                })
            }
        }
    }
}
