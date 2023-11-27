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
                guard let index = self.historyMessages.firstIndex(where: { $0.id == documentID}) else  { return }
                self.historyMessages.remove(at: index)
        
                if change.type == .removed {
                        self.historyMessages.remove(at: index)
                } else {
                    self.historyMessages.insert(message, at: 0)
                }
            }
        }
    }
    
    func converToCardModel(message: MessageModel) -> CardModel  {
        CardModel(id: message.id ?? "1", titleFormat: TextViewModel(text: message.message, foregroundColor: .black, font: .system(size: 14), expandable: false), designCard: ComponentDesign(backgroundColor: .gray.opacity(0.1), cornerRaiuds: 15),fromUUID: message.fromUUID ,toUUID: message.toUUID, action: "chat")
    }
}
