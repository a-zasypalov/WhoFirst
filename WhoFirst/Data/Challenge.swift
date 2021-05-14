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
    let winnerAlertTitle: String
    let winnerAlertButton: String
    let faultTryTitle: String
    let faultTrySubtitle: String
    let faultTryButton: String
    
    init?(data: [String: Any]) {
        guard let title = data[Challenge.titleField] as? String,
              let button = data[Challenge.buttonField] as? String,
              let winnerText = data[Challenge.winnerTextField] as? String,
              let loserText = data[Challenge.loserTextField] as? String,
              let participants = data[Challenge.participantsField] as? [String],
              let records = data[Challenge.recordsField] as? [String],
              let winnerAlertTitle = data[Challenge.winnerAlertTitleField] as? String,
              let winnerAlertButton = data[Challenge.winnerAlertButtonField] as? String,
              let faultTryTitle = data[Challenge.faultTryTitleField] as? String,
              let faultTrySubtitle = data[Challenge.faultTrySubtitleField] as? String,
              let faultTryButton = data[Challenge.faultTryButtonField] as? String
              else {return nil}
        
        self.title = title
        self.button = button
        self.winnerText = winnerText
        self.loserText = loserText
        self.participants = participants
        self.records = records
        self.winnerAlertTitle = winnerAlertTitle
        self.winnerAlertButton = winnerAlertButton
        self.faultTryTitle = faultTryTitle
        self.faultTryButton = faultTryButton
        self.faultTrySubtitle = faultTrySubtitle
    }
    
    static let titleField = "title"
    static let buttonField = "button"
    static let winnerTextField = "winner_text"
    static let winnerAlertTitleField = "winner_alert_title"
    static let winnerAlertButtonField = "winner_alert_button"
    static let faultTryTitleField = "fault_try_title"
    static let faultTrySubtitleField = "fault_try_subtitle"
    static let faultTryButtonField = "fault_try_button"
    static let loserTextField = "loser_text"
    static let participantsField = "participants"
    static let recordsField = "records"
}
