//
//  User.swift
//  WhoFirst
//
//  Created by Артем on 13.05.2021.
//

import Foundation

struct User {
    let login: String
    let password: String
    let email: String
    let sex: String
    var scores: String
    
    init?(data: [String: Any]) {
        guard let login = data[User.loginField] as? String,
              let password = data[User.passField] as? String,
              let sex = data[User.sexField] as? String,
              let scores = data[User.scoresField] as? String,
              let email = data[User.emailField] as? String
              else {return nil}
        
        self.login = login
        self.password = password
        self.sex = sex
        self.scores = scores
        self.email = email
    }
    
    var propertyListRepresentation : [String:String] {
            return [
                User.loginField : login,
                User.passField : password,
                User.sexField : sex,
                User.scoresField : scores,
                User.emailField : email
            ]
    }
    
    static let loginField = "login"
    static let passField = "password"
    static let sexField = "sex"
    static let scoresField = "scores"
    static let emailField = "email"
}
