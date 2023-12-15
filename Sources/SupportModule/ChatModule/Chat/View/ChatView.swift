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
                                .onTapGesture {
                                    showSheet.toggle()
                                }
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
            .sheet(isPresented: $viewModel.qualified, content: {
                CalifiationView(toUUID: viewModel.toUUID)
            })
            .onAppear{
                DispatchQueue.main.async {
                    viewModel.fetchingMessages()
                    viewModel.chatStatus()
                }
            }
            
            if !viewModel.finishedChat {
                 
                TextFieldMessageView( completion: { text in
                        viewModel.sendMessage(message: text)
                })
            }
        }
    }
}
