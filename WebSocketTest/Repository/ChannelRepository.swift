//
//  ChannelRepository.swift
//  WebSocketTest
//
//  Created by kbsys on 2023/01/30.
//

import Foundation

protocol ChannelRepository {
    func requestChannelList()
}

class ChannelRepositoryImpl:ChannelRepository {
    
    let CHANNEL_PREFIX = "hynix.client"
    let API_SELECT_CHANNEL_LIST = IS_CHANNEL_TREE ? "bizrunner.selectChannelTree" : "bizrunner.selectChannelList"
    
    init() {
        
    }
    
    func requestChannelList() {
        
    }
}
