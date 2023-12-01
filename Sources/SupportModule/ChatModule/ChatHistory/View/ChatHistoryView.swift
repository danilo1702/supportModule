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
    @State var selectedIndex: Int?
    @StateObject var viewModel = ChatHistoryViewModel()
    var body: some View {
        ScrollView{
            VStack {
                ForEach(viewModel.historyMessages) { message in
                   showMessages(message)
                }
            }
            .onAppear{
                    viewModel.gettingChatHistory()
            }
        }
        
    }
    
    @ViewBuilder
    func showMessages(_ message: CardModel) -> some View {
        
       
        NavigationLink {
            ChatView(supportInfo: MessageModel(message: "", fromUUID: message.fromUUID ?? "", toUUID: message.toUUID ?? "", fromName: message.nameFormat?.text ?? ""))
        } label: {
            Text("Vamos")
//            CardView(information: message, view: CardRecentMessageView(information: message).toAnyView()) {
//                goToChat.toggle()
//            }
        }
    }
}

#Preview {
    ChatHistoryView()
}
