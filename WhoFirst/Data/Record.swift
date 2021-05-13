//
//  Record.swift
//  WhoFirst
//
//  Created by Артем on 13.05.2021.
//

import Foundation

struct Record {
    let datetime: UInt64
    let winners: [String]
    let checked: Bool
    
    init?(data: [String: Any]) {
        guard let date = data[Record.datetimeField] as? UInt64,
              let checked = data[Record.checkedField] as? Bool
        else {return nil}
        
        self.datetime = date
        self.winners = data[Record.winnersField] as? [String] ?? [String]()
        self.checked = checked
    }
    
    static let datetimeField = "datetime"
    static let winnersField = "winners"
    static let checkedField = "checked"
}
