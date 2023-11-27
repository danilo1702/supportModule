//
//  ChatHistoryView.swift
//
//
//  Created by Danilo Hernandez on 27/11/23.
//

import SwiftUI

struct ChatHistoryView: View {
    @State var goToChat: Bool = false
    @StateObject var viewModel = ChatHistoryViewModel()
    var body: some View {
        ScrollView{
            VStack {
                ForEach(viewModel.historyMessages) { message in
                    NavigationLink(isActive: $goToChat) {
                        ChatView(toUUID: message.toUUID ?? "")
                    } label: {
                        CardView(information: message) {
                            goToChat.toggle()
                        }
                    }
                }
            }
            .onAppear{
                viewModel.gettingChatHistory()
            }
        }
        
    }
}

#Preview {
    ChatHistoryView()
}
