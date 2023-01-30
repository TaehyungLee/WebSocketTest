//
//  IntStringValue.swift
//  WebSocketTest
//
//  Created by kbsys on 2023/01/30.
//

import Foundation

enum IntStringValue: Codable {
    case string(String)
    case int(Int)

    var stringValue: String? {
        switch self {
        case .string(let s):
            return s
        case .int(let i):
            return "\(i)"
        }
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(Int.self) {
            self = .int(x)
            return
        }
        throw DecodingError.typeMismatch(IntStringValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for IntStringValue"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .int(let x):
            try container.encode(x)
        }
    }
}
