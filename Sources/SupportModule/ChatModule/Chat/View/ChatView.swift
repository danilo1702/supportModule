//
//  ChatView.swift
//
//
//  Created by Danilo Hernandez on 31/10/23.
//

import SwiftUI

public struct ChatView: View {
    
    @StateObject var viewModel: ChatViewModel
    var scrollBottom = "scrollBottom"
    @State public var textToSend: String = ""
    @State var showSheet: Bool = false
    public init(toUUID: String) {
        self._viewModel = StateObject(wrappedValue: ChatViewModel(toUUID: toUUID))
    }
    public var body: some View {
        
        VStack {
            ScrollView{
                ScrollViewReader { scrollViewProxy in
                    VStack{
                        ForEach(viewModel.messages, id: \.uniqueID) { message in
                            
                           BumbleChat(message: message)
                        }
                        HStack {
                            Spacer()
                        }.id(scrollBottom)
                    }.onReceive(viewModel.$count, perform: { _ in
                        withAnimation(.smooth) {
                            scrollViewProxy.scrollTo(scrollBottom, anchor: .bottom)
                        }
                    })
                }
            }
            .onAppear{
                
                DispatchQueue.main.async {
                    viewModel.fetchingMessages()
                    viewModel.chatStatus()
                    
                }
            }
            .navigationTitle(CommonStrings.chatSupport)
            if !viewModel.finishedChat {
                 
                TextFieldMessageView( completion: { text in
                        viewModel.sendMessage(message: text)
                })
            }
            
        }.sheet(isPresented: $viewModel.finishedChat) {
            CalifiationView()
        }
        
    }
}
