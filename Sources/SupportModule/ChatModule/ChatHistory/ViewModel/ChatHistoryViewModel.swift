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
    private var dbFirestore = Firestore.firestore()
    @Published var historyMessages: [CardModel] = []
    
    func gettingChatHistory() {
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        let reference = dbFirestore.collection("lastMessages")
            .document(uuid)
            .collection("messages")
        
        reference.getDocuments { [weak self] querySnapshot, error in
            guard let self = self, let querySnapshot, error == nil else { return }
            
            querySnapshot.documentChanges.forEach {  change in
                
                guard  let messageModel = try? change.document.data(as: MessageModel.self) else { return }
                let documentID = change.document.documentID
                let message = self.converToCardModel(message: messageModel)
                
                if change.type == .added {
                    self.historyMessages.insert(message, at: 0)
                } else if change.type == .modified {
                    if let index = self.historyMessages.firstIndex(where: { $0.id ==  documentID }) {
                        self.historyMessages.insert(message, at: index)
                    }
                } else if change.type == .removed {
                    if let index = self.historyMessages.firstIndex(where: { $0.id ==  documentID }) {
                        self.historyMessages.remove(at: index)
                    }
                }
            }
        }
    }
    
    func converToCardModel(message: MessageModel) -> CardModel  {
        CardModel(id: message.id ?? "1", titleFormat: TextViewModel(text: message.message, foregroundColor: .black, font: .system(size: 14), expandable: false), designCard: ComponentDesign(backgroundColor: .gray.opacity(0.1), cornerRaiuds: 15),fromUUID: message.fromUUID ,toUUID: message.toUUID, action: "chat")
    }
}
