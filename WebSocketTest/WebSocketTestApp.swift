//
//  WebSocketTestApp.swift
//  WebSocketTest
//
//  Created by kbsys on 2023/01/30.
//

import SwiftUI

@main
struct WebSocketTestApp: App {
    var body: some Scene {
        WindowGroup {
            IntroView(session: SocketSessionImpl())
        }
    }
}
