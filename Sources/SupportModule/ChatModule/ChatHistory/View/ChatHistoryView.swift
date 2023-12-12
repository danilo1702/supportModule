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
                        NavigationLink {
                            ChatView(toUUID: (message.toUUID ?? "" ==  Auth.auth().currentUser?.uid ? message.fromUUID ?? "" : message.toUUID ?? ""))
                        } label: {
                            CardView(information: message, view: CardRecentMessageView(information: message).toAnyView()) {}
                        }
                    }
                }
            }
//            NavigationLink(isActive: $goToChat, destination: {
//                ChatView(toUUID: toUUID)
//            }, label: {
//                EmptyView()
//            })
            .task(priority: .background, {
                DispatchQueue.main.async {
                    viewModel.gettingChatHistory()
                }
            })
            
        }
    }
}

#Preview {
    ChatHistoryView()
}
