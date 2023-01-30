//
//  ChannelModel.swift
//  MessengerSwiftUI
//
//  Created by KBSYS on 2022/07/06.
//

import Foundation

struct CubeChannelData:Hashable, Identifiable {
    let id = UUID().uuidString
    var isExpanded = false
    
    var lv = 0
    var sortKey = 0
    var channelId = ""
    var parentId = 0
    var channelName = ""
    var channelType = ""        // F:폴더, T:알림차단폴더, C:채널
    var channelInfoType = 0     
    var notifyYn = ""
    
    var depth = ""
    
    var sysName = ""
    var isFreezing = ""
    var channel_sysop_id:[Int] = []
    
    var unreadCnt = 0
    var isMention = false
    
    var channel_group_id = 0
    var children:[CubeChannelData]? = nil
    
    init(channelName:String) {
        self.channelName = channelName
    }
    
    init(chInfo:GroupChannelInfoModel, langIdx:Int) {
        self.channelId = chInfo.channel_id?.stringValue ?? ""
        self.parentId = chInfo.channel_group_id ?? 0
        
        if let aliasChannelName = chInfo.aliasChannelName, aliasChannelName != "" {
            self.channelName = aliasChannelName
        }else if let name_m = chInfo.channel_name_m, name_m.count > langIdx,
                 name_m[langIdx] != "" {
            self.channelName = name_m[langIdx]
        }else if let chName = chInfo.channel_name {
            self.channelName = chName
        }
        
        if let grp_id = chInfo.channel_group_id {
            self.channel_group_id = grp_id
        }
        
        if let type = chInfo.channel_type {
            self.channelInfoType = type
        }
        
        self.unreadCnt = 0
        
    }
    
    init(chInfo:CubeChannelInfoModel, groupInfoList:[GroupChannelModel]?, langIdx:Int) {
        self.channelId = chInfo.channel_id.stringValue ?? ""
        self.parentId = chInfo.channel_group_id ?? 0
        
        if let aliasChannelName = chInfo.aliasChannelName, aliasChannelName != "" {
            self.channelName = aliasChannelName
        }else if let name_m = chInfo.channel_name_m, name_m.count > langIdx,
                 name_m[langIdx] != "" {
            self.channelName = name_m[langIdx]
        }else if let chName = chInfo.channel_name {
            self.channelName = chName
        }
        
        if let grp_id = chInfo.channel_group_id {
            self.channel_group_id = grp_id
        }
        
        if let type = chInfo.channel_type {
            self.channelInfoType = type
        }
        
        self.unreadCnt = 0
        
        // 폴더
        if self.channelId == "-1" {
            self.channelType = "F"
            self.channelName = chInfo.channel_group_name ?? ""
            
            if let grpList = groupInfoList {
                // 다중 depth 가 아니라 2뎁스 고정이기때문에 children으로는 폴더가 올수없고 채널만 가능
                self.children = grpList
                .filter({ $0.channel_info != nil })
                .filter({ ($0.channel_info!.channel_group_id ?? 0) == self.parentId })
                .map({ model in
                    return CubeChannelData(chInfo: model.channel_info!, langIdx: langIdx)
                })
            }
            
        }
        
        
    }
    
    init(tree:CubeChannelTreeModel, info:CubeChannelInfoModel?, child:[CubeChannelData]?, langIdx:Int) {
        
        self.lv = tree.lv ?? 0
        self.sortKey = tree.sortKey ?? 0
        self.channelId = tree.channelId.stringValue ?? ""
        self.parentId = tree.parentId ?? 0
        self.channelType = tree.channelType ?? ""
        self.notifyYn = tree.notifyYn ?? ""
        
        self.isFreezing = tree.isFreezing ?? ""
        self.sysName = tree.sysName ?? ""
        self.channel_sysop_id = tree.channel_sysop_id  ?? []
        
        self.channel_group_id = 0
        
        if let aliasChannelName = tree.aliasChannelName, aliasChannelName != "" {
            self.channelName = aliasChannelName
        }else if (self.channelType == "F" || self.channelType == "T"),
                 let chName = tree.channelName {
            // 폴더, 알림차단함
            self.channelName = chName
        }else if let name_m = info?.channel_name_m, name_m.count > langIdx,
                 name_m[langIdx] != "" {
            self.channelName = name_m[langIdx]
        }else if let chName = info?.channel_name {
            self.channelName = chName
        }
        
        if let channelInfo = info {
            if let grp_id = channelInfo.channel_group_id {
                self.channel_group_id = grp_id
            }
            
            if self.channelName == "", let chName = channelInfo.channel_name {
                self.channelName = chName
            }
            
            if let type = channelInfo.channel_type {
                self.channelInfoType = type
            }
            
        }
        
        self.children = child
        self.unreadCnt = 0
        
    }
    
}

struct RootChannelOldModel:Decodable {
    let api:String?
    let result:RootChannelOldResultModel?
}

struct RootChannelOldResultModel:Decodable {
    let type:String?
    let address:String?
    let body:CubeChannelOldModel?
}

struct CubeChannelOldModel:Decodable {
    let bizWorksChannelList:[BizWorksChannelModel]?
    let groupInChannelList:[GroupChannelModel]?
}

struct BizWorksChannelModel:Decodable {
    let channel_info:CubeChannelInfoModel?
}

struct GroupChannelModel:Decodable {
    let channel_info:GroupChannelInfoModel?
}

struct GroupChannelInfoModel:Decodable {
    let aliasChannelName:String?
    let channel_sysopid:Int?
    
    let NAMELANG1:String?
    let NAMELANG2:String?
    let NAMELANG3:String?
    let NAMELANG4:String?
    let NAMELANG5:String?
    
    let goodDocs_icon1:String?
    let goodDocs_icon2:String?
    let goodDocs_icon3:String?
    let goodDocs_icon4:String?
    let goodDocs_icon5:String?
    let goodDocs_icon6:String?
    let goodDocs_icon7:String?
    let goodDocs_icon8:String?
    let goodDocs_icon9:String?
    let goodDocs_icon10:String?
    
    let doc_search:String?
    let videoUrl:String?
    let channel_group_id:Int?
    let sysName:String?
    let channel_type:Int?
    let docm_search:String?
    let channel_name:String?
    let channel_name_m:[String]?
    let memberadd_yn:String?
    let active:String?
    
    let iflowUrl:String?
    let chatBotSetYN:String?
    let channel_group_name:String?
    let channel_register:Int?
    
    let m_open:String?
    let goodDocs_url1:String?
    
    let channel_id:IntStringValue?
    
    
}

struct RootChannelModel:Decodable {
    let api:String?
    let type:String?
    let address:String?
    let result:RootChannelResultModel?
    let body:String?
    
}

struct RootChannelResultModel:Decodable {
    let type:String?
    let address:String?
    let body:CubeChannelModel?
}

struct CubeChannelModel:Decodable {
    let cubeChannelTree:[CubeChannelTreeModel]
    let cubeChannelInfo:[CubeChannelInfoModel]
    let alarmCutChannels:[IntStringValue]?
}

struct CubeChannelTreeModel:Decodable {
    let lv:Int?
    let sortKey:Int?
    let channelId:IntStringValue
    let parentId:Int?
    let channelName:String?
    let channelType:String?
    let notifyYn:String?
    let aliasChannelName:String?
    let sysName:String?
    let isFreezing:String?
    
    let child:[CubeChannelTreeModel]?
    let channel_sysop_id:[Int]?
}

struct CubeChannelInfoModel:Decodable {
    let channel_id:IntStringValue
    let channel_group_id:Int?
    let channel_group_name:String?
    let channel_type:Int?
    let docm_search:String?
    let doc_search:String?
    let m_open:String?
    let active:String?
    let channel_name:String?
    let memberadd_yn:String?
    let unique_name:String?
    let videoUrl:String?
    let iflowUrl:String?
    let goodDocsUrl1:String?
    let goodDocsName1:String?
    let chatBotUrl1:String?
    let chatBotSetYN:String?
    let sysName:String?
    
    let aliasChannelName:String?
    let channel_name_m:[String]?
    let channel_sysop_name:String?
    let register:Int?
    
    let channel_sysop_uniqueName:[String]?
    let channel_sysop_id:[Int]?
    
    let channel_intro:String?
    let alarmYN:String?
    
    let channel_notice:String?
    let channel_notice1:String?
    let channel_notice2:String?
    
    let isTrashBox:String?
}


// TP : CHANNEL CREATE
struct RootChCreatePushModel:Decodable {
    let api:String?
    let type:String?
    let address:String?
    let result:RootChCreatePushResult?
    let body:String?
}

struct RootChCreatePushResult:Decodable {
    let type:String?
    let address:String?
    
    let body:RootChCreatePushBody?
}

struct RootChCreatePushBody:Decodable {
    let channel_info:CubeChannelInfoModel?
}

// TP_CHANNEL_MESSAGE_SYNC - unread count
struct RootChMsgSyncPushModel:Decodable {
    let api:String?
    let type:String?
    let address:String?
    let result:RootChMsgSyncPushResult?
    let body:String?
}

struct RootChMsgSyncPushResult:Decodable {
    let type:String?
    let address:String?
    
    let body:RootChMsgSyncPushBody?
}

struct RootChMsgSyncPushBody:Decodable {
    let list:[String]?
}
