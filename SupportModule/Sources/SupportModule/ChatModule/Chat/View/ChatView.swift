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

    public init(toUUID: String) {
        self._viewModel = StateObject(wrappedValue: ChatViewModel(toUUID: toUUID))
    }
    public var body: some View {
       
        VStack {
                ScrollView{
                    ScrollViewReader { scrollViewProxy in
                        VStack{
                            ForEach(viewModel.messages, id: \.timestamp) { message in
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
                TextFieldMessageView( completion: {text in 
                    viewModel.sendMessage(message: text)
                })
                    .navigationTitle(CommonStrings.chatSupport)
                    .onAppear{
                        
                        DispatchQueue.main.async {
                            viewModel.fetchingMessages()
                        }
                        
                    }
            }
            
        
    }
}

//#Preview {
//    ChatView()
//}