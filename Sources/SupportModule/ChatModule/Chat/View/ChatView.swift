//
//  ChatView.swift
//
//
//  Created by Danilo Hernandez on 31/10/23.
//

import SwiftUI

public struct ChatView: View {
    
    @StateObject var viewModel: ChatViewModel

    public init(toUUID: String) {
        self._viewModel = StateObject(wrappedValue: ChatViewModel(toUUID: toUUID))
    }
    public var body: some View {
        
            VStack {
                ScrollView {
                    ForEach(viewModel.messages, id: \.id) { message in
                        BumbleChat(message: message)
                    }  
                }
                TextFieldMessageView( completion: { text in 
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
