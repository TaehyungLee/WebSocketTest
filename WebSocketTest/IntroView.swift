//
//  IntroView.swift
//  MessengerSwiftUI
//
//  Created by KBSYS on 2022/06/15.
//

import SwiftUI
import Combine

struct IntroView: View {
    
    @StateObject var vm:IntroViewModel
    
    init(session:SocketSessionImpl) {
        self._vm = StateObject(wrappedValue: IntroViewModel(session: session,
                                                            repository: LoginRepositoryImpl()))
    }
    
    var body: some View {
        ZStack(alignment:.center) {
            WebView(session: vm.session)
                .frame(width: 0.0, height: 0.0)
            if vm.showMainView {
                ChannelView(service: ChannelServiceImpl(session: vm.session,
                                                        repository: ChannelRepositoryImpl()))
            }else{
                VStack {
                    Text("Loading...")
                    ProgressView()
                }
            }
        }
    }
    
}
