//
//  ChannelViewModel.swift
//  WebSocketTest
//
//  Created by kbsys on 2023/01/30.
//

import Foundation
import Combine

class ChannelViewModel:ObservableObject {
    
    private var cancelBag = Set<AnyCancellable>()
    
    @Published var alertInfo:AlertInfo?
    
    @Published var channelList:[CubeChannelData] = []
    @Published var isLoading = false
    
    let service:ChannelService
    
    init(service:ChannelService) {
        self.service = service
        
        self.isLoading = true
        self.service.requestChannelList { [weak self] complete in
            self?.isLoading = false
            switch complete {
            case .success(let list):
                self?.channelList = list
                break
            case .failure(_):
                self?.alertInfo = AlertInfo(id: .error,
                                           title: "Error",
                                           message: "채널리스트 조회에 실패하였습니다.")
                break
            }
        }
        
        
    }
    
}

extension ChannelViewModel {
    struct AlertInfo: Identifiable {
        enum AlertType {
            case error          // 에러
        }
        
        let id: AlertType
        let title: String
        let message: String
    }
}
