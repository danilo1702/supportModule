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
                                
                                CardView(information: message, view: CardRecentMessageView(information: message).toAnyView(), indicator: Binding(get: {message.indicator ?? false}, set: {  $0 })) {
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
                    .onAppear {
                        DispatchQueue.main.async {
                            viewModel.gettingChatHistory()
                        }
                    }
                    
            }
    }
}

#Preview {
    ChatHistoryView()
}
