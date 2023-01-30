//
//  SocketModel.swift
//  WebSocketTest
//
//  Created by kbsys on 2023/01/30.
//

import Foundation

struct WebSocketData:Codable {
    let api:String?
    let type:String?
    let address:String?
    let result:WebSocketResult?
    let body:String?
}

struct WebSocketResult:Codable {
    let type:String?
    let address:String?
    
}
