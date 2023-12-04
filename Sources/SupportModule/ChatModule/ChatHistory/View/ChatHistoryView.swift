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
                        NavigationLink(isActive: $goToChat) {
                            ChatView(supportInfo: MessageModel(message: "", fromUUID: "6WGRA6SLvucx1jxXShfQMQJPdbE3", toUUID: "V1RfRkJiCNVKl45yb81wqroAsQS2", fromName: "Simulator iPhone 15 Pro"))
                        } label: {
                            CardView(information: message, view: CardRecentMessageView(information: message).toAnyView()) {
                                goToChat.toggle()
                            }
                        }
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
        
        NavigationLink(isActive: $goToChat) {
            ChatView(supportInfo: MessageModel(message: "", fromUUID: "6WGRA6SLvucx1jxXShfQMQJPdbE3", toUUID: "V1RfRkJiCNVKl45yb81wqroAsQS2", fromName: "Simulator iPhone 15 Pro"))
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
