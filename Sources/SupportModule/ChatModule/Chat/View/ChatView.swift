//
//  ChatView.swift
//
//
//  Created by Danilo Hernandez on 31/10/23.
//

import SwiftUI

public struct ChatView: View {
    
    @State var messageToSend: String = ""

    public var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    
                    ForEach(MockInformation.messages, id: \.uiniqueId) { message in

                        if let specialMessage =  message.specialMessage {
                            MessageBubble(messageStruct: message, view:  SelectOptionView(messageModel: specialMessage).toAnyView(), geometry: geometry)
                        } else {
                            MessageBubble(messageStruct: message, geometry: geometry)
                        }
                    }
                }
                TextFieldMessageView()
                    .navigationTitle(CommonStrings.chatSupport)
            }
        }
    }
}

#Preview {
    ChatView()
}
