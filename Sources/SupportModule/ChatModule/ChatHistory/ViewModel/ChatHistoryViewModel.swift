//
//  ChatHistoryViewModel.swift
//
//
//  Created by Danilo Hernandez on 27/11/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

public class ChatHistoryViewModel: ObservableObject {
    
    @Published var historyMessages: [CardModel] = []
    
    func gettingChatHistory() {
        guard let uuid = FirebaseManagerData.initialization.dbAuth.currentUser?.uid else { return }
        
        let reference = FirebaseManagerData.initialization.dbFirestore.collection(FirebaseConstants.lastMessages)
            .document(uuid)
            .collection(FirebaseConstants.messages)
        
        
        reference.getDocuments { [weak self] querySnapshot, error in
            guard let self = self , let querySnapshot = querySnapshot, error == nil else { return }
            
            
            querySnapshot.documents.forEach {  change in
                
                guard  let messageModel = try? change.data(as: MessageModel.self) else { return }
                
                //let documentID = change.document.documentID
                
                let message = self.converToCardModel(message: messageModel, userUUID: uuid)
                
                self.historyMessages.append(CardModel(id: "x9TaSl4d1fV0cB058EdSjRAXpnq2", titleFormat: TextViewModel(text: "to X9", foregroundColor: .black, font: .system(size: 14), expandable: false), dateFormat: TextViewModel(text: "Hora", foregroundColor: .gray, font: .system(size: 11),  expandable: false), nameFormat:  TextViewModel(text:"Tu", foregroundColor: .black, font: .system(size: 13, weight: .bold), expandable: false), designCard: ComponentDesign(backgroundColor: .gray.opacity(0.1), cornerRaiuds: 15),fromUUID: "NpObDASer0WH7izVyeKzz6b0Rqt2" ,toUUID: "x9TaSl4d1fV0cB058EdSjRAXpnq2", action: "chat"))
                
                self.historyMessages.append(CardModel(id: "nNz25KH4SoS4FujvKXHMeu3Iain2", titleFormat: TextViewModel(text: "to NN", foregroundColor: .black, font: .system(size: 14), expandable: false), dateFormat: TextViewModel(text: "Hora", foregroundColor: .gray, font: .system(size: 11),  expandable: false), nameFormat:  TextViewModel(text:"Tu", foregroundColor: .black, font: .system(size: 13, weight: .bold), expandable: false), designCard: ComponentDesign(backgroundColor: .gray.opacity(0.1), cornerRaiuds: 15),fromUUID: "NpObDASer0WH7izVyeKzz6b0Rqt2" ,toUUID: "nNz25KH4SoS4FujvKXHMeu3Iain2", action: "chat"))
                
//                if let index = self.historyMessages.firstIndex(where: { $0.id == documentID}) {
//                    self.historyMessages.remove(at: index)
//                }
//                if change.type == .added || change.type == .modified {
//                    self.historyMessages.insert(message, at: 0)
//                } else if change.type == .removed {
//                    if let index = self.historyMessages.firstIndex(where: { $0.id ==  documentID }) {
//                        self.historyMessages.remove(at: index)
//                    }
//                }
                
            }
        }
    }

    func converToCardModel(message: MessageModel, userUUID: String) -> CardModel  {
        
        CardModel(id: message.id ?? "1", titleFormat: TextViewModel(text: message.message, foregroundColor: .black, font: .system(size: 14), expandable: false), dateFormat: TextViewModel(text: "\(String(describing: message.timestamp!.dateValue().formatted(date: .numeric, time: .shortened)))", foregroundColor: .gray, font: .system(size: 11),  expandable: false), nameFormat:  TextViewModel(text: userUUID == message.fromUUID ? "Tú:" : message.fromName, foregroundColor: .black, font: .system(size: 13, weight: .bold), expandable: false), designCard: ComponentDesign(backgroundColor: .gray.opacity(0.1), cornerRaiuds: 15),fromUUID: message.fromUUID ,toUUID: message.toUUID, action: "chat")
    }
}
