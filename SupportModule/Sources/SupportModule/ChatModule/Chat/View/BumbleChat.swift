//
//  BumbleChat.swift
//
//
//  Created by Danilo Hernandez on 23/11/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct BumbleChat: View {
    var message: MessageModel
    
    var body: some View {
        VStack {
            if message.fromUUID == Auth.auth().currentUser?.uid {
                HStack {
                  
                    Spacer()
                    HStack {
                        Text(message.message)
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                }
            } else {
                
                HStack {
                    HStack {
                        Text(message.message)
                            .foregroundStyle(.black)
                    }
                    
                    .padding()
                    .background(.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    Spacer()
                }
            }
        }
    }
}

//#Preview {
//    BumbleChat(message: MessageModel(message: "Hola buen dia", fromUUID: "hola", toUUID: "", timestamp: Timestamp()))
//}
