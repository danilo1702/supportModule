//
//  MessageBubble.swift
//
//
//  Created by Danilo Hernandez on 31/10/23.
//

import SwiftUI

struct MessageBubble: View {
    
    public var messageStruct: MessagesStruct
    public var sendMessage: ComponentDesign = ComponentDesign(backgroundColor: Color.init(hex: "#F6F1E8"), cornerRaiuds: 15)
    public var receiveMessage: ComponentDesign =  ComponentDesign(backgroundColor: .gray.opacity(0.1), cornerRaiuds: 15)
    public var view: AnyView?
    public var geometry: GeometryProxy
    
    //save image in cache
    var body: some View {
        VStack {
            CardView(information: CardModel(id: messageStruct.id, image: ImageModel(image: messageStruct.linkImage ?? ""), titleFormat: messageStruct.message ?? TextViewModel(text: ""), dateFormat: messageStruct.date, designCard: messageStruct.receive ? receiveMessage : sendMessage), view: view, completion: {})
                .padding(.horizontal, 10)
                
        }
    }
}

//#Preview {
//    MessageBubble(messageStruct: MessagesStruct(id: "1", linkImage: "", message:  TextViewModel(text: "Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en hola", expandable: true), date: TextViewModel(text: "15:20", foregroundColor: .gray.opacity(0.2), font: .system(size: 12)), receive: true))
//}
