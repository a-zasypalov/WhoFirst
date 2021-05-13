//
//  Challenge.swift
//  WhoFirst
//
//  Created by Артем on 13.05.2021.
//

import Foundation

struct Challenge {
    let title: String
    let participants: [String]
    let records: [String]
    
    init?(data: [String: Any]) {
        guard let title = data[Challenge.titleField] as? String,
              let participants = data[Challenge.participantsField] as? [String],
              let records = data[Challenge.recordsField] as? [String]
              else {return nil}
        
        self.title = title
        self.participants = participants
        self.records = records
    }
    
    static let titleField = "title"
    static let participantsField = "participants"
    static let recordsField = "records"
}
