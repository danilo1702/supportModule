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
    public init(supportInfo: MessageModel) {
        self._viewModel = StateObject(wrappedValue: ChatViewModel(supportInfo: supportInfo))
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
            
            
            TextFieldMessageView( completion: { text in
                DispatchQueue.main.async {
                    viewModel.sendMessage(message: text)
                }
            })
            .onAppear{
                
                DispatchQueue.main.async {
                    viewModel.fetchingMessages()
                }
                
            }
            .navigationTitle(CommonStrings.chatSupport)
        }
        
        
    }
    
}

//#Preview {
//    ChatView()
//}
