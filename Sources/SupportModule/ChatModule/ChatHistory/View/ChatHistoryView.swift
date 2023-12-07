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
    
    var body: some View {
                ScrollView{
                    VStack {
                        ForEach(viewModel.historyMessages, id: \.uniqueId) { message in
                            VStack{
                                showMessages(message)
                            }
                        }
                    }
                    
                    .onAppear{
                        DispatchQueue.main.async {
                            viewModel.gettingChatHistory()
                        }
                    }
            }
        
    }
    
    @ViewBuilder
    func showMessages(_ message: CardModel) -> some View {
        let toUUID = (message.toUUID ?? "" ==  Auth.auth().currentUser?.uid ? message.fromUUID ?? "" : message.toUUID ?? "")
        //if let fromUUID = message.fromUUID, let toUUID = message.toUUID, let fromName = message.nameFormat?.text {
            
            NavigationLink(isActive: $goToChat) {
                ChatView(toUUID:  toUUID)
            } label: {
                CardView(information: message, view: CardRecentMessageView(information: message).toAnyView()) {
                    goToChat.toggle()
                }
            }
       // }
    }
}

#Preview {
    ChatHistoryView()
}
