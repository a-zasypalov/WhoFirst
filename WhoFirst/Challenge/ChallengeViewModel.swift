//
//  ChallengeViewModel.swift
//  WhoFirst
//
//  Created by Артем on 13.05.2021.
//

import Firebase
import FirebaseFirestore

class ChallengeViewModel : ObservableObject {
    
    static let STATUS_UNDEFINED = 0
    static let STATUS_WINNER = 1
    static let STATUS_LOSER = 2
    static let STATUS_PLAY = 3
    
    @Published var challenge: Challenge? = nil
    @Published var current: Record? = nil
    @Published var status = STATUS_UNDEFINED
    @Published var image = "UnicornQuestion"
    
    private let db = Firestore.firestore()
    
    func getChallenge() {
        db.collection("challenges").document("Shower")
            .getDocument() { (documentSnapshot, err) in
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
        if(current != nil) {
            if(!current!.checked && Date.init() >= Date(timeIntervalSince1970: TimeInterval(current!.datetime) / 1000)) {
                
                status = ChallengeViewModel.STATUS_UNDEFINED
                
                db.collection("records").document(self.challenge!.records.last!)
                    .updateData([
                        Record.checkedField : true,
                        Record.winnersField : [UserDefaults.standard.string(forKey: UserDefaultsKeys.userId)]
                    ])
                
                var dateComponent = DateComponents()
                dateComponent.day = 1
                
                let newDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Calendar.current.date(byAdding: dateComponent, to: Date.init())!)
                
                db.collection("records").addDocument(data: [
                    Record.checkedField : false,
                    Record.winnersField : Array<String>(),
                    Record.datetimeField : Int64((newDate!.timeIntervalSince1970 * 1000.0).rounded())
                ])
                
                getChallenge()
                
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
