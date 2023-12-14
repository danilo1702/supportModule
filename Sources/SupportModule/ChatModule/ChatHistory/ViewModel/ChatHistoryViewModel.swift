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
            
        
        reference.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self , let querySnapshot = querySnapshot, error == nil else { return }
            
            
            querySnapshot.documentChanges.forEach {  change in
                
                guard  let messageModel = try? change.document.data(as: MessageModel.self) else { return }
                  
                let documentID = change.document.documentID

                let message = self.converToCardModel(message: messageModel, userUUID: uuid)
               
                if let index = self.historyMessages.firstIndex(where: { $0.id == documentID}) {
                    self.historyMessages.remove(at: index)
                }
                if change.type == .added || change.type == .modified {
                    self.historyMessages.insert(message, at: 0)
                }
            }
        }
    }
    func updateToReadChat(toUUID: String) {
        guard let uuid = FirebaseManagerData.initialization.dbAuth.currentUser?.uid else { return }
        let reference  = FirebaseManagerData.initialization.dbFirestore.collection(FirebaseConstants.lastMessages)
            .document(uuid)
            .collection(FirebaseConstants.messages)
            .document(toUUID)
        
        reference.getDocument { documentSnaphshot, error in
            
            guard let snapshot = documentSnaphshot, error == nil else { return }
        
            if let status = snapshot.data()?["messageRead"] as? Bool {
                if status {
                    reference.updateData(["messageRead" : false])
                }
            }
        }
        
        
    }
    
    func converToCardModel(message: MessageModel, userUUID: String) -> CardModel  {
        
        CardModel(id: message.id ?? "1", titleFormat: TextViewModel(text: message.message, foregroundColor: .black, font: .system(size: 14), expandable: false), dateFormat: TextViewModel(text: "\(String(describing: message.timestamp!.dateValue().formatted(date: .numeric, time: .shortened)))", foregroundColor: .gray, font: .system(size: 11),  expandable: false), nameFormat:  TextViewModel(text: userUUID == message.fromUUID ? "Tú:" : message.fromName, foregroundColor: .black, font: .system(size: 13, weight: .bold), expandable: false), designCard: ComponentDesign(backgroundColor: .gray.opacity(0.1), cornerRaiuds: 15),fromUUID: message.fromUUID ,toUUID: message.toUUID, indicator: message.messageRead, action: "chat")
    }
}
