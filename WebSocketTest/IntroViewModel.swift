//
//  IntroViewModel.swift
//  WebSocketTest
//
//  Created by kbsys on 2023/01/30.
//

import SwiftUI
import Combine

class IntroViewModel:ObservableObject {
    
    @Published var showMainView = false
    
    private var cancelBag = Set<AnyCancellable>()
    
    let session: SocketSessionImpl
    let repository:LoginRepository
    init(session: SocketSessionImpl, repository:LoginRepository) {
        self.session = session
        self.repository = repository
        self.addSubscribe()
    }
    
    private func addSubscribe() {
        
        // html, js 파일로드 완료시 uuid요청
        self.session.webViewloadFinish
            .sink { [weak self] isLoadFinish in
                if isLoadFinish {
                    self?.repository.requestLogin(userID: TEST_ID, completion: { result in
                        switch result {
                        case .success(let data):
                            if let uuidStr = String(data: data, encoding: .utf8) {
                                DEBUG_LOG("resultStr : \(uuidStr)")
                                // socket connect
                                DispatchQueue.main.async {
                                    self?.session.connect(uuidStr: uuidStr)
                                }
                                
                            }
                            break
                        case .failure(let error):
                            DEBUG_LOG("login error : \(error.localizedDescription)")
                            break
                        }
                    })
                }
            }
            .store(in: &cancelBag)
        
        self.session.socketConnectFinish
            .sink { [weak self] isSocketConnect in
                if isSocketConnect {
                    DEBUG_LOG("Socket Connect!!!")
                    self?.showMainView = true
                }
            }
            .store(in: &cancelBag)
    }
    
}
