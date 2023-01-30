//
//  ChannelView.swift
//  WebSocketTest
//
//  Created by kbsys on 2023/01/30.
//

import SwiftUI

struct ChannelView: View {
    
    @StateObject var vm:ChannelViewModel
    
    init(service:ChannelService) {
        self._vm = StateObject(wrappedValue: ChannelViewModel(service: service))
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    ForEach(vm.channelList) { channel in
                        Text(channel.channelName)
                            .padding(.all)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red, lineWidth: 1)
                            )
                    }
                }
            }
            
            if vm.isLoading {
                ProgressView()
            }
        }
        .alert(item: $vm.alertInfo, content: { info in
            return Alert(
                title: Text(info.title),
                message: Text(info.message),
                dismissButton: .default(Text("확인"), action: {
                    
                })
            
            )
        })
        
    }
               
               
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView(service: ChannelServiceImpl(session: SocketSessionImpl(), repository: ChannelRepositoryImpl()))
    }
}
