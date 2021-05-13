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
    let sex: String
    
    init?(data: [String: Any]) {
        guard let login = data[User.loginField] as? String,
              let password = data[User.passField] as? String,
              let sex = data[User.sexField] as? String
              else {return nil}
        
        self.login = login
        self.password = password
        self.sex = sex
    }
    
    var propertyListRepresentation : [String:String] {
            return [
                User.loginField : login,
                User.passField : password,
                User.sexField : sex
            ]
    }
    
    static let loginField = "login"
    static let passField = "password"
    static let sexField = "sex"
}
