//
//  SocketSession.swift
//  WebSocketTest
//
//  Created by kbsys on 2023/01/30.
//

import Foundation
import Combine


enum SocketError: Error {
    case noData
    case decodingJSON
    case unKnown
}

protocol SocketSession {
    func connect(uuidStr:String)
    func disconnect()
    func reconnect()
    func send(scriptStr:String)
}

// 소켓 연결, 요청, 응답 처리
class SocketSessionImpl:SocketSession {
    
    let functionCaller = PassthroughSubject<String, Never>()
    let didRecieveMessage = PassthroughSubject<Any, Never>()
    let webViewloadFinish = CurrentValueSubject<Bool, Never>(false)
    let socketConnectFinish = CurrentValueSubject<Bool, Never>(false)
    
    // Channel Response
    let channelListResponseMessage = PassthroughSubject<Data, Never>()
    private var channelListResponse:AnyCancellable?
    
    private var cancelBag = Set<AnyCancellable>()
    
    init() {
        self.addSubscribe()
    }
    
    private func addSubscribe() {
        
        didRecieveMessage
            .sink { [weak self] body in
                // decode
                self?.apiCallbackProc(body)
            }
            .store(in: &cancelBag)
        
    }
    
    func connect(uuidStr:String) {
        let scriptStr = "setTimeout(connect('\(BASE_URL)/eventbus', '\(uuidStr)', '1'), 1000);"
        self.send(scriptStr: scriptStr)
    }
    
    func disconnect() {
        let scriptStr = "disconnect()"
        self.send(scriptStr: scriptStr)
    }
    
    func reconnect() {
        
    }
    
    func doRequest(kind:String, header:[String:Any]?, body:[String:Any]?,
                   callback:@escaping (Result<Data,SocketError>)->Void) {
        let scriptStr = "send('\(kind)', '\(header?.json ?? "")', '\(body?.json ?? "")');"
        self.send(scriptStr:scriptStr)
        
        // send 하고 응답 대기(옵저버 변수)하여 응답오면 리턴
        // ( 요청할때 unique address를 보내서 받을때 address로 구분하여 요청에 대한응답 맵핑 필요 )
        if kind == API_SELECT_CHANNEL_LIST {
            self.channelListResponse = self.channelListResponseMessage
                .sink { [weak self] returnedData in
                    DEBUG_LOG("self.channelListResponse response enter")
                    guard let self = self else { return }
                    callback(.success(returnedData))
                    self.channelListResponse?.cancel()
                }
        }
        
    }
    
    func send(scriptStr:String) {
        DEBUG_LOG("scriptStr : \(scriptStr)")
        self.functionCaller.send(scriptStr)
    }
    
}

// MARK: Socket Response methods
extension SocketSessionImpl {
    
    struct SocketResult {
        let response:Any?
        let error:Error?
        let errorMessage:String?
    }
    
    func decodeProc<T:Decodable>(_ data:Data, type:T.Type) -> SocketResult {
        do {
            let response = try JSONDecoder().decode(type.self, from: data)
            return SocketResult(response: response, error: nil, errorMessage: nil)
        }
        catch let DecodingError.dataCorrupted(context) {
           DEBUG_LOG(context)
            return SocketResult(response: nil, error: DecodingError.dataCorrupted(context), errorMessage: context.debugDescription)
       } catch let DecodingError.keyNotFound(key, context) {
           DEBUG_LOG("Key '\(key)' not found:\(context.debugDescription)")
           DEBUG_LOG("codingPath:\(context.codingPath)")
           return SocketResult(response: nil, error: DecodingError.keyNotFound(key, context), errorMessage: context.debugDescription)
       } catch let DecodingError.valueNotFound(value, context) {
           DEBUG_LOG("Value '\(value)' not found:\(context.debugDescription)")
           DEBUG_LOG("codingPath:\(context.codingPath)")
           return SocketResult(response: nil, error: DecodingError.valueNotFound(value, context), errorMessage: context.debugDescription)
       } catch let DecodingError.typeMismatch(type, context)  {
           DEBUG_LOG("Type '\(type)' mismatch:\(context.debugDescription)")
           DEBUG_LOG("codingPath:\(context.codingPath)")
           return SocketResult(response: nil, error: DecodingError.typeMismatch(type, context), errorMessage: context.debugDescription)
       } catch {
           DEBUG_LOG("error: \(error.localizedDescription)")
           return SocketResult(response: nil, error: error, errorMessage: error.localizedDescription)
       }
    }
    
    func apiCallbackProc(_ body:Any) {
        if let jsonStr = body as? String {
            if let data = jsonStr.data(using: .utf8) {
                let result = decodeProc(data, type: WebSocketData.self)
                if let response = result.response as? WebSocketData {
                    if let apiStr = response.api {
                        switch apiStr {
                        case "auth":
                            self.socketConnectFinish.send(true)
                            break
                        case "push":
                            break
                        default:
                            
                            if apiStr == API_SELECT_CHANNEL_LIST {
                                self.channelListResponseMessage.send(data)
                            }
                            
                            break
                        }
                    }
                }
                
            }
            
        }else{
            DEBUG_LOG("Error apiCallbackProc")
        }
    }
}
