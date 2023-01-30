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
    print("❗️ [\(filename)] \(funcName)(\(line)): \(msg)")
    #endif
}

func ERROR_LOG(_ msg:Any, file: String = #file, function: String = #function, line:Int = #line) {
    let filename = file.split(separator: "/").last ?? ""
    let funcName = function.split(separator: "(").first ?? ""
    print("🚫 [\(filename)] \(funcName)(\(line)): \(msg)")
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
//let TEST_ID = "I0101555"    // 이지원 차장
//let TEST_ID = "X0123661"    // 이성하 수석

let IS_CHANNEL_TREE = false     // true : 채널 트리구조 요청, false : 2뎁스 채널리스트요청 ( 폴더 - 채널 )

let DIST_SERVER = false         // true: 운영, false: 개발

let BASE_URL = "http://110.45.156.137:10209"
