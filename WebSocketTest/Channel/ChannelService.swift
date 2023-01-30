//
//  ChannelService.swift
//  WebSocketTest
//
//  Created by kbsys on 2023/01/30.
//

import Foundation
import Combine

protocol ChannelService {
    func requestChannelList(completion:@escaping (Result<[CubeChannelData], SocketError>)->Void)
    
}


class ChannelServiceImpl:ChannelService {
    
    private var cancelBag = Set<AnyCancellable>()
    
    private let langIdx = 0
    
    let session: SocketSessionImpl
    let repository:ChannelRepository
    
    init(session: SocketSessionImpl, repository:ChannelRepository) {
        self.session = session
        self.repository = repository
        
    }
    
    func requestChannelList(completion:@escaping (Result<[CubeChannelData], SocketError>)->Void) {
        self.session.doRequest(kind: API_SELECT_CHANNEL_LIST, header: nil, body: IS_CHANNEL_TREE ? ["type":"CUBE"] : nil, callback: { result in
            switch result {
            case .success(let data):
                completion(self.responseChannelList(data))
                break
            case .failure(let err):
                completion(.failure(err))
                break
            }
        })
        
    }
}

// MARK: Channel Socket Response
extension ChannelServiceImpl {
    
    private func responseChannelList(_ data:Data) -> Result<[CubeChannelData], SocketError> {
        if IS_CHANNEL_TREE {
            let socketResult = self.session.decodeProc(data, type: RootChannelModel.self)
            if let nResponse = socketResult.response as? RootChannelModel,
               let result = nResponse.result,
               let body = result.body {
                return .success(self.channelDataFetch(body))
            }else{
                return .failure(.decodingJSON)
            }
        }else{
            let socketResult = self.session.decodeProc(data, type: RootChannelOldModel.self)
            if let nResponse = socketResult.response as? RootChannelOldModel,
               let result = nResponse.result,
               let body = result.body,
               // 1depth에 있는 채널 or 폴더 리스트
               let bizChList = body.bizWorksChannelList {
                let channelList = bizChList.filter({ $0.channel_info != nil }).map { model in
                    return CubeChannelData(chInfo: model.channel_info!, groupInfoList: body.groupInChannelList, langIdx: self.langIdx)
                }
                
                return .success(channelList)
                
            }else{
                return .failure(.decodingJSON)
            }
        }
    }
    
    private func channelDataFetch(_ chdata:CubeChannelModel)-> [CubeChannelData] {
        let treeList = chdata.cubeChannelTree
        var list:[CubeChannelData] = []
        
        for tree in treeList {
            let infoList = chdata.cubeChannelInfo
            let data = self.makeCubeChannelData(tree: tree, infoList: infoList)
            list.append(data)
            
        }
        
        // depth 값 추가
        for i in 0..<list.count {
            var data = list[i]
            data = self.addDepthChannelData(data: data, idx: i)
            list[i] = data
        }
        
        // 알림 차단 리스트
        
        
        // return
        return list
        
    }
    
    private func addDepthChannelData(data:CubeChannelData, idx:Int) -> CubeChannelData {
        
        var resultData = data
        
        if resultData.depth == "" {
            resultData.depth = "\(idx)"
        }
        
        if let child = resultData.children, child.count > 0,
           (resultData.channelType == "F" || resultData.channelType == "T") {
            for i in 0..<child.count {
                var childData = child[i]
                childData.depth = "\(resultData.depth)-\(i)"
                childData = self.addDepthChannelData(data: childData, idx: i)
            }
        }
        
        return resultData
    }
    
    private func makeCubeChannelData(tree:CubeChannelTreeModel, infoList:[CubeChannelInfoModel]) -> CubeChannelData {
        let findInfo = self.findChannelInfo(chInfoList: infoList, target: tree)
        
        var child:[CubeChannelData]? = nil
        
        if let childTree = tree.child, childTree.count > 0,
           let chType = tree.channelType, (chType == "F" || chType == "T") {
            var child_idx = -1
            for treeData in childTree {
                child_idx = child_idx+1
                var data = self.makeCubeChannelData(tree: treeData, infoList: infoList)
                data.depth = ""
                if child == nil {
                    child = []
                }
                child?.append(data)
            }
        }
        
        var obj = CubeChannelData(tree: tree, info: findInfo, child: child, langIdx: self.langIdx)
        obj.depth = ""
        
        return obj
    }
    
    private func findChannelInfo(chInfoList:[CubeChannelInfoModel], target:CubeChannelTreeModel) -> CubeChannelInfoModel? {
        guard let targetChannelId = target.channelId.stringValue, targetChannelId != "" else { return nil }
        for info in chInfoList {
            let channel_id = info.channel_id.stringValue ?? ""
            if targetChannelId == channel_id {
                return info
            }
        }
        
        return nil
    }
    
    
    
}
