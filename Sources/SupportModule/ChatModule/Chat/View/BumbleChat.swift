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
    @State var selection : String = ""
    @State var imageSignature: UIImage? = nil
    
    init(message: MessageModel) {
        self.message = message
    }
    
    var body: some View {
        VStack {
            if message.fromUUID == Auth.auth().currentUser?.uid {
                HStack {
                  
                    Spacer()
                    HStack {
                        showMessage()
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                }
            } else {
                
                HStack {
                    HStack {
                        showMessage()
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
    
    @ViewBuilder
    func showMessage() -> some View {
        
       let type =  TypeMessage(rawValue: message.type)
        
        switch type {
            case .multipleChoice:
                 SelectOptionViewV2(messageModel: message, selection: $selection)
            case .onChoice:
                SelectOptionViewV2(messageModel: message, selection: $selection)
            case .text:
                Text(message.message)
            case .signature:
                DrawViewChat(image: $imageSignature)
            case nil:
                EmptyView()
        }
    }
}

//#Preview {
//    BumbleChat(message: MessageModel(message: "Hola buen dia", fromUUID: "hola", toUUID: "", timestamp: Timestamp()))
//}
