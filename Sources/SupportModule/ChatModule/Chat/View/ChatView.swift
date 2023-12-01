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
            showTextField()
//                TextFieldMessageView( completion: { text in
//                    DispatchQueue.main.async {
//                        viewModel.sendMessage(message: text)
//                    }                                    
//                })
                    .navigationTitle(CommonStrings.chatSupport)
                    .onAppear{
                        
                        DispatchQueue.main.async {
                            viewModel.fetchingMessages()
                        }
                        
                    }
        }
            
        
    }
    @ViewBuilder
    func showTextField() -> some View {
        HStack(alignment: .bottom){
            
            Button(action: {}, label: {
                Image(systemName: "photo.badge.plus.fill")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.07, height: UIScreen.main.bounds.width * 0.07, alignment: .bottomLeading)
                    .foregroundStyle(.blue)
            })
            
                TextEditor(text: $textToSend)
                    .frame(minHeight: 35)
                    .fixedSize(horizontal: false, vertical: true)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                if textToSend.isEmpty {
                    Button(action: {}, label: {
                        Image(systemName: "mic.circle.fill")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.07, height: UIScreen.main.bounds.width * 0.07, alignment: .center)
                    })
                } else {
                    Button(action: {
                        
                        viewModel.sendMessage(message: textToSend)
                        textToSend = ""
                    }, label: {
                        Image(systemName: "paperplane.circle.fill")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.07, height: UIScreen.main.bounds.width * 0.07, alignment: .center)
                            .rotationEffect(.degrees(45))
                            
                    })
                }
           
        }.padding()
            .background(.gray.opacity(0.1))
    }
}

//#Preview {
//    ChatView()
//}
