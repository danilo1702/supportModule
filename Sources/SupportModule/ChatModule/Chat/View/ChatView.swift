//
//  ChatView.swift
//
//
//  Created by Danilo Hernandez on 31/10/23.
//

import SwiftUI

public struct ChatView: View {
    var messages: [MessagesStruct] = [
        MessagesStruct(id: "1", message: TextViewModel(text: "Hola, necesito ayuda"), date: TextViewModel(text: "8/11/2023"), receive: false),
        MessagesStruct(id: "4", linkImage: "https://media.licdn.com/dms/image/C4E0BAQE2XFQtSRiHZQ/company-logo_200_200/0/1656405313746/tribal_spain_logo?e=2147483647&v=beta&t=R7R5-tGgcQAoTvGbs6hLScx4xEczAnesII9r4PAoSWs", date: TextViewModel(text: "8/11/2023"), receive: true, specialMessage: SpecialMessage(metaData: MockInformation.metaDataCheckBox2)),
        MessagesStruct(id: "2", linkImage: "https://media.licdn.com/dms/image/C4E0BAQE2XFQtSRiHZQ/company-logo_200_200/0/1656405313746/tribal_spain_logo?e=2147483647&v=beta&t=R7R5-tGgcQAoTvGbs6hLScx4xEczAnesII9r4PAoSWs", message: TextViewModel(text: "Hola, Juaquin, un gusto en saludarte"), date: TextViewModel(text: "8/11/2023"), receive: true),
        MessagesStruct(id: "4", linkImage: "https://media.licdn.com/dms/image/C4E0BAQE2XFQtSRiHZQ/company-logo_200_200/0/1656405313746/tribal_spain_logo?e=2147483647&v=beta&t=R7R5-tGgcQAoTvGbs6hLScx4xEczAnesII9r4PAoSWs", date: TextViewModel(text: "8/11/2023"), receive: true, specialMessage: SpecialMessage(metaData: MockInformation.metaDataCheckBox)),
        MessagesStruct(id: "2", linkImage: "https://media.licdn.com/dms/image/C4E0BAQE2XFQtSRiHZQ/company-logo_200_200/0/1656405313746/tribal_spain_logo?e=2147483647&v=beta&t=R7R5-tGgcQAoTvGbs6hLScx4xEczAnesII9r4PAoSWs", message: TextViewModel(text: "Cuentame, en que te puedo colaborar"), date: TextViewModel(text: "8/11/2023"), receive: true),
        MessagesStruct(id: "1", message: TextViewModel(text: "No puedo hacer una transferencia, me sale error de conexion"), date: TextViewModel(text: "8/11/2023"), receive: false), MessagesStruct(id: "1", message: TextViewModel(text: "Hola, necesito ayuda"), date: TextViewModel(text: "8/11/2023"), receive: false),
        MessagesStruct(id: "2", linkImage: "https://media.licdn.com/dms/image/C4E0BAQE2XFQtSRiHZQ/company-logo_200_200/0/1656405313746/tribal_spain_logo?e=2147483647&v=beta&t=R7R5-tGgcQAoTvGbs6hLScx4xEczAnesII9r4PAoSWs", message: TextViewModel(text: "Hola, Juaquin, un gusto en saludarte"), date: TextViewModel(text: "8/11/2023"), receive: true),
        MessagesStruct(id: "2", linkImage: "https://media.licdn.com/dms/image/C4E0BAQE2XFQtSRiHZQ/company-logo_200_200/0/1656405313746/tribal_spain_logo?e=2147483647&v=beta&t=R7R5-tGgcQAoTvGbs6hLScx4xEczAnesII9r4PAoSWs", message: TextViewModel(text: "Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en hola", expandable: true), date: TextViewModel(text: "8/11/2023"), receive: true),
        MessagesStruct(id: "1", message: TextViewModel(text: "No puedo hacer una transferencia, me sale error de conexion"), date: TextViewModel(text: "8/11/2023"), receive: false)]
    @State var messageToSend: String = ""

    public var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    
                    ForEach(messages, id: \.uiniqueId) { message in

                        if let specialMessage =  message.specialMessage {
                            MessageBubble(messageStruct: message, view:  SelectOptionView(messageModel: specialMessage).toAnyView(), geometry: geometry)
                        } else {
                            MessageBubble(messageStruct: message, geometry: geometry)
                        }
                    }
                }
                TextFieldMessageView()
                    .navigationTitle("Chat Support")
            }
        }
    }
}

#Preview {
    ChatView()
}
