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
    @Published var supportInformation = PersonalInformationUser(email: "", uuid: "", name: "")
    
    func gettingChatHistory() {
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        
        let reference = dbFirestore.collection("lastMessages")
            .document(uuid)
            .collection("messages")
        
        reference.getDocuments { [weak self] querySnapshot, error in
            guard let self = self, let querySnapshot, error == nil else { return }
            
            
            querySnapshot.documentChanges.forEach {  change in
                
                guard  let messageModel = try? change.document.data(as: MessageModel.self) else { return }
                
                
                let toUUID = (messageModel.toUUID ==  Auth.auth().currentUser?.uid ? messageModel.fromUUID : messageModel.toUUID )
                  
                let documentID = change.document.documentID
                let message = self.converToCardModel(message: messageModel)
               
                
                if let index = self.historyMessages.firstIndex(where: { $0.id == documentID}) {
                    self.historyMessages.remove(at: index)
                }
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
        CardModel(id: message.id ?? "1", titleFormat: TextViewModel(text: message.message, foregroundColor: .black, font: .system(size: 14), expandable: false),dateFormat: TextViewModel(text: "\(message.timestamp.dateValue().formatted(date: .numeric, time: .shortened))", foregroundColor: .gray, font: .system(size: 11),  expandable: false), nameFormat:  TextViewModel(text: message.fromName, foregroundColor: .black, font: .system(size: 13, weight: .bold), expandable: false), designCard: ComponentDesign(backgroundColor: .gray.opacity(0.1), cornerRaiuds: 15),fromUUID: message.fromUUID ,toUUID: message.toUUID, action: "chat")
    }
}
