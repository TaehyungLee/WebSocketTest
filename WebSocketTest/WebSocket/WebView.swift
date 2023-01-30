//
//  WebView.swift
//  MessengerSwiftUI
//
//  Created by KBSYS on 2022/06/13.
//

import SwiftUI
import WebKit
import Combine

struct WebView: UIViewRepresentable {
    let session: SocketSessionImpl
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(session: session)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        let wv = context.coordinator.webView
        if let path = Bundle.main.path(forResource: "vertx_ios_base", ofType: "html") {
            do {
                wv.loadHTMLString(try String(contentsOfFile: path), baseURL: URL(string: BASE_URL))
            } catch {
                DEBUG_LOG("error : \(error.localizedDescription)")
            }
        }else{
            DEBUG_LOG("vertx_ios_base.html load fail ")
        }
        context.coordinator.tieFunctionCaller()
        
        return wv
    }
    
    func updateUIView(_ nsView: WKWebView, context: Context) {
        
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
        let session: SocketSessionImpl
        
        var webView: WKWebView = WKWebView()
        var loadedUrl: URL? = nil
        
        private var cancelBag = Set<AnyCancellable>()
        
        init(session: SocketSessionImpl) {
            self.session = session
            super.init()
            let userContentController = WKUserContentController()
            userContentController.add(self, name: "send")
            userContentController.add(self, name: "regist")
            userContentController.add(self, name: "unRegist")
            userContentController.add(self, name: "push")
            
            self.loadScript("sockjs-1.1.0.min", contentsController: userContentController)
            self.loadScript("vertx-eventbus", contentsController: userContentController)
            self.loadScript("json2", contentsController: userContentController)
            self.loadScript("vertx_ios", contentsController: userContentController)
            
            let configuration = WKWebViewConfiguration()
            configuration.userContentController = userContentController
            let _wkwebview = WKWebView(frame: .zero, configuration: configuration)
            _wkwebview.navigationDelegate = self
            _wkwebview.uiDelegate = self
            webView = _wkwebview
            
        }
        
        private func loadScript(_ fileNameStr:String, contentsController:WKUserContentController) {
            var content = ""
            if let path = Bundle.main.path(forResource: "/\(fileNameStr)", ofType: "js") {
                do {
                    content = try String(contentsOfFile: path)
                } catch {
                    DEBUG_LOG("error : \(error.localizedDescription)")
                }
            }else{
                DEBUG_LOG("loadScript fail : \(fileNameStr)")
            }
            let userScript = WKUserScript(source: content, injectionTime: .atDocumentStart, forMainFrameOnly: true)
            contentsController.addUserScript(userScript)
            
        }
        
        func tieFunctionCaller() {
            
            session.functionCaller
                .sink { scriptStr in
                    self.webView.evaluateJavaScript(scriptStr) { id, err in
                        if let error = err {
                            // javascript error
                            DEBUG_LOG("javascript error : \(error.localizedDescription)")
                        }
                    }
                }.store(in: &cancelBag)

        }
        
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                     completionHandler: @escaping () -> Void) {
            DEBUG_LOG("💚💚💚 runJavaScriptAlertPanelWithMessage message : \(message)")
            
            // 서버에서 연결 끊어지면 알려줌
            if message == "eventbus.onclose" {
                // 소켓 끊어지면 App 리스타트
                session.reconnect()
            }
            
            completionHandler()
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            DEBUG_LOG("message.name : \(message.name)")
            DEBUG_LOG("message.body : \(message.body)")
            
            session.didRecieveMessage.send(message.body)
            
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DEBUG_LOG("WKWebView didFinish")
            DispatchQueue.main.async {
                // html, js 파일 로드 끝나면
                self.session.webViewloadFinish.send(true)
                
            }
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
    
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            showError(title: "Navigation Error", message: error.localizedDescription)
            DispatchQueue.main.async {
    
            }
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            showError(title: "Loading Error", message: error.localizedDescription)
            DispatchQueue.main.async {
    
            }
        }
        
        
        func showError(title: String, message: String) {
    #if os(macOS)
            let alert: NSAlert = NSAlert()
            
            alert.messageText = title
            alert.informativeText = message
            alert.alertStyle = .warning
            
            alert.runModal()
    #else
            DEBUG_LOG("\(title): \(message)")
    #endif
        }
    }
}


