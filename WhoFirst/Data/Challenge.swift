//
//  Challenge.swift
//  WhoFirst
//
//  Created by Артем on 13.05.2021.
//

import Foundation

struct Challenge {
    let title: String
    let button: String
    let winnerText: String
    let loserText: String
    let participants: [String]
    let records: [String]
    
    init?(data: [String: Any]) {
        guard let title = data[Challenge.titleField] as? String,
              let button = data[Challenge.buttonField] as? String,
              let winnerText = data[Challenge.winnerTextField] as? String,
              let loserText = data[Challenge.loserTextField] as? String,
              let participants = data[Challenge.participantsField] as? [String],
              let records = data[Challenge.recordsField] as? [String]
              else {return nil}
        
        self.title = title
        self.button = button
        self.winnerText = winnerText
        self.loserText = loserText
        self.participants = participants
        self.records = records
    }
    
    static let titleField = "title"
    static let buttonField = "button"
    static let winnerTextField = "winner_text"
    static let loserTextField = "loser_text"
    static let participantsField = "participants"
    static let recordsField = "records"
}
