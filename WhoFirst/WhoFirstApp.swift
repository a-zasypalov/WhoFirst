//
//  WhoFirstApp.swift
//  WhoFirst
//
//  Created by Артем on 12.05.2021.
//

import SwiftUI
import Firebase

@main
struct WhoFirstApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
