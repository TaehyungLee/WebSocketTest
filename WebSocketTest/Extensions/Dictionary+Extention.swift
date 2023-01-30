//
//  DictionaryExtention.swift
//  MessengerSwiftUI
//
//  Created by KBSYS on 2022/06/16.
//

import Foundation

extension Dictionary {

    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

    func printJson() {
        DEBUG_LOG(json)
    }

}
