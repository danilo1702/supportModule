//
//  ChatHistoryView.swift
//
//
//  Created by Danilo Hernandez on 27/11/23.
//

import SwiftUI
import FirebaseAuth

struct ChatHistoryView: View {
    
    @State var goToChat: Bool = false
    @StateObject var viewModel = ChatHistoryViewModel()
    @State var toUUID: String = ""
    
    var body: some View {
                ScrollView{
                    VStack {
                        ForEach(viewModel.historyMessages, id: \.uniqueId) { message in
                            VStack{
                                CardView(information: message, view: CardRecentMessageView(information: message).toAnyView()) {
                                    toUUID =  (message.toUUID ?? "" ==  Auth.auth().currentUser?.uid ? message.fromUUID ?? "" : message.toUUID ?? "")
                                    goToChat.toggle()
                                    
                                }
                            }
                        }
                    }
                    NavigationLink(isActive: $goToChat, destination: {
                        ChatView(toUUID: toUUID)
                    }, label: {
                        EmptyView()
                    })
                    .task(priority: .background, {
                        DispatchQueue.main.async {
                            viewModel.gettingChatHistory()
                        }
                    })
                    
            }
    }
    
    @ViewBuilder
    func showMessages(_ message: CardModel) -> some View {
        let toUUID = (message.toUUID ?? "" ==  Auth.auth().currentUser?.uid ? message.fromUUID ?? "" : message.toUUID ?? "")
        print("TO UUID \(toUUID)" )
        print("message: \(message.titleFormat.text)")
        
        return     NavigationLink(isActive: $goToChat) {
                ChatView(toUUID:  toUUID)
            } label: {
                CardView(information: message, view: CardRecentMessageView(information: message).toAnyView()) {
                    goToChat.toggle()
                }
            }
    }
}

#Preview {
    ChatHistoryView()
}
