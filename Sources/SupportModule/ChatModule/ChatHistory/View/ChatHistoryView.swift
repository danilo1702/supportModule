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
                    ForEach(viewModel.historyMessages) { message in
                        showMessages(message)
                    }
                }
                .onAppear{
                    DispatchQueue.global().async {
                        viewModel.gettingChatHistory()
                    }
                }
           
        }
    }
    
    @ViewBuilder
    func showMessages(_ message: CardModel) -> some View {
        if let fromUUID = message.fromUUID, let toUUID = message.toUUID, let fromName = message.nameFormat?.text {
            
            NavigationLink(isActive: $goToChat) {
                ChatView(supportInfo: MessageModel(message: "", fromUUID: fromUUID, toUUID: toUUID, fromName: fromName))
            } label: {
                CardView(information: message, view: CardRecentMessageView(information: message).toAnyView()) {
                    goToChat.toggle()
                }
            }
        }
    }
}

#Preview {
    ChatHistoryView()
}
