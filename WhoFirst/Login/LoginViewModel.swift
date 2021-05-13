//
//  LoginViewModel.swift
//  WhoFirst
//
//  Created by Артем on 13.05.2021.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    
    @Published var user: User? = nil
    
    private let db = Firestore.firestore()
    
    func authorize(login: String, pass: String) {
        db.collection("users")
            .whereField(User.loginField, isEqualTo: login)
            .whereField(User.passField, isEqualTo: pass)
            .getDocuments() { (querySnapshot, err) in
                if(querySnapshot != nil && querySnapshot!.documents.first != nil) {
                    self.user = User(data: (querySnapshot!.documents.first!.data()))
                    UserDefaults.standard.set(self.user?.propertyListRepresentation, forKey: UserDefaultsKeys.userKey)
                    UserDefaults.standard.set(querySnapshot?.documents.first?.documentID, forKey: UserDefaultsKeys.userId)
                }
            }
    }
    
}
