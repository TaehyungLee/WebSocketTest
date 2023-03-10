//
//  Global.swift
//  MessengerSwiftUI
//
//  Created by KBSYS on 2022/09/15.
//

import Foundation

func DEBUG_LOG(_ msg:Any, file: String = #file, function: String = #function, line:Int = #line) {
    #if DEBUG
    let filename = file.split(separator: "/").last ?? ""
    let funcName = function.split(separator: "(").first ?? ""
    print("βοΈ [\(filename)] \(funcName)(\(line)): \(msg)")
    #endif
}

func ERROR_LOG(_ msg:Any, file: String = #file, function: String = #function, line:Int = #line) {
    let filename = file.split(separator: "/").last ?? ""
    let funcName = function.split(separator: "(").first ?? ""
    print("π« [\(filename)] \(funcName)(\(line)): \(msg)")
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        self == nil || self == ""
    }
    
    var orEmpty: String {
        self ?? ""
    }
    
}


#if targetEnvironment(simulator)
  // Simulator
let TARGET_IPHONE_SIMULATOR = true
#else
  // Device
let TARGET_IPHONE_SIMULATOR = false
#endif

let TEST_ID = "THLEE"
//let TEST_ID = "X0124377"
//let TEST_ID = "I0101555"    // μ΄μ§μ μ°¨μ₯
//let TEST_ID = "X0123661"    // μ΄μ±ν μμ

let IS_CHANNEL_TREE = false     // true : μ±λ νΈλ¦¬κ΅¬μ‘° μμ²­, false : 2λμ€ μ±λλ¦¬μ€νΈμμ²­ ( ν΄λ - μ±λ )

let DIST_SERVER = false         // true: μ΄μ, false: κ°λ°

let BASE_URL = "http://110.45.156.137:10209"
