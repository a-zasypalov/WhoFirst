//
//  ChallengeViewModel.swift
//  WhoFirst
//
//  Created by Артем on 13.05.2021.
//

import Firebase
import FirebaseFirestore
import SwiftUI

class ChallengeViewModel : ObservableObject {
    
    static let STATUS_UNDEFINED = 0
    static let STATUS_WINNER = 1
    static let STATUS_LOSER = 2
    static let STATUS_PLAY = 3
    static let OLD_EVENT = 4
    static let STATUS_WAIT = 5
    
    @Published var challenge: Challenge? = nil
    @Published var current: Record? = nil
    @Published var status = STATUS_UNDEFINED
    @Published var image = "UnicornQuestion"
    
    @Published var openAlert = false
    var alertImage = "UnicornQuestion"
    var alertText = ""
    var alertSubtitle = ""
    var alertButtonText = ""
    
    private let db = Firestore.firestore()
    
    func getChallenge() {
        db.collection("challenges").document("Shower")
            .addSnapshotListener() { (documentSnapshot, err) in
                if(documentSnapshot != nil && documentSnapshot?.data() != nil) {
                    self.challenge = Challenge(data: documentSnapshot!.data()!)
                    
                    if(self.challenge!.records.count > 1) {
                        self.getCurrentRecord(id: self.challenge!.records.last!, prevId: self.challenge!.records[self.challenge!.records.count-2])
                    } else if(!self.challenge!.records.isEmpty) {
                        self.getCurrentRecord(id: self.challenge!.records.last!, prevId: nil)
                    }
                }
            }
    }
    
    func tryToWinToday() {
        if(self.current != nil) {
            if(!self.current!.checked && Date.init() >= Date(timeIntervalSince1970: TimeInterval(self.current!.datetime) / 1000)) {
                self.status = ChallengeViewModel.STATUS_UNDEFINED
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    
                    if Reachability.isConnectedToNetwork(){
                        self.db.collection("records").document(self.challenge!.records.last!)
                            .updateData([
                                Record.checkedField : true,
                                Record.winnersField : [UserDefaults.standard.string(forKey: UserDefaultsKeys.userId)]
                            ]) { err in
                                if err != nil {
                                    self.alertImage = "UnicornNo"
                                    self.alertText = "Что-то пошло не так!"
                                    self.alertButtonText = "Назад"
                                    self.openAlert = true
                                } else {
                                    var dateComponent = DateComponents()
                                    dateComponent.day = 1
                                    let newDate = Calendar.current.date(bySettingHour: Int.random(in: 12..<19), minute: Int.random(in: 0..<59), second: Int.random(in: 0..<59), of: Calendar.current.date(byAdding: dateComponent, to: Date.init())!)
                                    
                                    var newDoc: DocumentReference? = nil
                                    newDoc = self.db.collection("records").addDocument(data: [
                                        Record.checkedField : false,
                                        Record.winnersField : Array<String>(),
                                        Record.datetimeField : Int64((newDate!.timeIntervalSince1970 * 1000.0).rounded())
                                    ]) { err in
                                        if err != nil {
                                            self.alertImage = "UnicornNo"
                                            self.alertText = "Что-то пошло не так!"
                                            self.alertButtonText = "Назад"
                                            self.openAlert = true
                                        } else {
                                            var newChallenges = self.challenge?.records
                                            newChallenges?.append(newDoc!.documentID)
                                            
                                            self.db.collection("challenges").document("Shower").updateData([Challenge.recordsField: newChallenges!])
                                            
                                            var savedUser = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.userKey).flatMap { User(data: $0)} ?? nil
                                            savedUser!.scores = String(Int64(savedUser!.scores)! + 1)
                                            UserDefaults.standard.setValue(savedUser!.propertyListRepresentation, forKey: UserDefaultsKeys.userKey)
                                            
                                            self.db.collection("users").document(UserDefaults.standard.string(forKey: UserDefaultsKeys.userId)!)
                                                .updateData([
                                                    User.scoresField : savedUser!.scores,
                                                ]) { err in
                                                    if err != nil {
                                                        self.alertImage = "UnicornNo"
                                                        self.alertText = "Что-то пошло не так!"
                                                        self.alertButtonText = "Назад"
                                                        self.openAlert = true
                                                    } else {
                                                        self.alertImage = "UnicornOk"
                                                        self.alertText = self.challenge!.winnerAlertTitle
                                                        self.alertSubtitle = ""
                                                        self.alertButtonText = self.challenge!.winnerAlertButton
                                                        self.openAlert = true
                                                        
                                                        self.getChallenge()
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                        
                    } else {
                        self.alertImage = "UnicornNo"
                        self.alertText = "Что-то пошло не так!"
                        self.alertButtonText = "Назад"
                        self.openAlert = true
                    }
                }
            } else {
                self.alertImage = "UnicornAgain"
                self.alertText = self.challenge!.faultTryTitle
                self.alertSubtitle = self.challenge!.faultTrySubtitle
                self.alertButtonText = self.challenge!.faultTryButton
                self.openAlert = true
            }
        }
    }
    
    func createNewRecord() {
        self.status = ChallengeViewModel.STATUS_UNDEFINED
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            if Reachability.isConnectedToNetwork(){
                self.db.collection("records").document(self.challenge!.records.last!)
                    .updateData([
                        Record.checkedField : true,
                    ]) { err in
                        if err != nil {
                            self.alertImage = "UnicornNo"
                            self.alertText = "Что-то пошло не так!"
                            self.alertButtonText = "Назад"
                            self.openAlert = true
                        } else {
                            var dateComponent = DateComponents()
                            dateComponent.day = 1
                            let newDate = Calendar.current.date(bySettingHour: Int.random(in: 12..<19), minute: Int.random(in: 0..<59), second: Int.random(in: 0..<59), of: Calendar.current.date(byAdding: dateComponent, to: Date.init())!)
                            
                            var newDoc: DocumentReference? = nil
                            newDoc = self.db.collection("records").addDocument(data: [
                                Record.checkedField : false,
                                Record.winnersField : Array<String>(),
                                Record.datetimeField : Int64((newDate!.timeIntervalSince1970 * 1000.0).rounded())
                            ]) { err in
                                if err != nil {
                                    self.alertImage = "UnicornNo"
                                    self.alertText = "Что-то пошло не так!"
                                    self.alertButtonText = "Назад"
                                    self.openAlert = true
                                } else {
                                    var newChallenges = self.challenge?.records
                                    newChallenges?.append(newDoc!.documentID)
                                    
                                    self.db.collection("challenges").document("Shower-test").updateData([Challenge.recordsField: newChallenges!])
                                    
                                    self.alertImage = "UnicornCool"
                                    self.alertText = "Игра продолжается!"
                                    self.alertSubtitle = "До завтра"
                                    self.alertButtonText = "Ура!"
                                    self.openAlert = true
                                    
                                    self.getChallenge()
                                }
                            }
                        }
                    }
            }
        }
    }
    
    private func getCurrentRecord(id: String, prevId: String?) {
        db.collection("records").document(id)
            .getDocument() { (documentSnapshot, err) in
                if(documentSnapshot != nil && documentSnapshot?.data() != nil) {
                    let lastRecord = Record(data: documentSnapshot!.data()!)
                    
                    let now = Date.init()
                    let df = DateFormatter()
                    df.dateFormat = "dd"
                    
                    if(lastRecord != nil) {
                        if(df.string(from: now) == df.string(from: Date(timeIntervalSince1970: TimeInterval(lastRecord!.datetime) / 1000))) {
                            //If the record is in future
                            self.current = lastRecord
                            self.checkStatus()
                        } else if(prevId != nil){
                            //If we have previous record
                            self.db.collection("records").document(prevId!)
                                .getDocument() { (documentSnapshot, err) in
                                    if(documentSnapshot != nil && documentSnapshot?.data() != nil) {
                                        self.current = Record(data: documentSnapshot!.data()!)
                                        self.checkStatus()
                                    }
                                }
                        } else {
                            self.current = Record(data: documentSnapshot!.data()!)
                            self.checkStatus()
                        }
                    }
                }
                
            }
    }
    
    private func checkStatus() {
        if(current != nil) {
            let now = Date.init()
            let df = DateFormatter()
            df.dateFormat = "dd"
            
            if(!current!.checked && df.string(from: now) == df.string(from: Date(timeIntervalSince1970: TimeInterval(current!.datetime) / 1000))) {
                self.status = ChallengeViewModel.STATUS_PLAY
                self.image = "UnicornFoxy"
            } else if(now > Date(timeIntervalSince1970: TimeInterval(current!.datetime) / 1000)) {
                if(!current!.checked) {
                self.status = ChallengeViewModel.OLD_EVENT
                self.image = "UnicornOops"
                } else {
                    self.status = ChallengeViewModel.STATUS_WAIT
                    self.image = "UnicornAgain"
                }
            } else {
                if(current!.winners.contains(UserDefaults.standard.string(forKey: UserDefaultsKeys.userId)!)) {
                    self.status = ChallengeViewModel.STATUS_WINNER
                    self.image = "UnicornHappy"
                } else {
                    self.status = ChallengeViewModel.STATUS_LOSER
                    self.image = "UnicornScared"
                }
            }
            
        }
    }
    
}
