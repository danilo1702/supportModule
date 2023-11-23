//
//  ChatViewModel.swift
//
//
//  Created by Danilo Hernandez on 23/11/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    let dbFirestore = Firestore.firestore()
    let toUUID: String
    @Published var messages: [MessageModel] = []
    
    public init(toUUID: String) {
        self.toUUID = toUUID
    }
    
    func fetchingMessages() {
        
        guard let fromUUID = Auth.auth().currentUser?.uid else { return }
        
        let reference = dbFirestore.collection(FirebaseConstants.messages)
            .document(fromUUID)
            .collection(toUUID)
            .order(by: FirebaseConstants.timestamp)
        
        reference.addSnapshotListener { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot, error == nil else { return }
            
            documentSnapshot.documentChanges.forEach { change in
                if change.type == .added {
                    
                    if let cm = try? change.document.data(as: MessageModel.self) {
                        self.messages.append(cm)
                        print("Appending chatMessage in Chat: \(Date())")
                    }
                }
            }
        }
    }
    
    func sendMessage(message: String) {
        
        guard let fromUUID = Auth.auth().currentUser?.uid else { return }
        let referenceSender = dbFirestore.collection(FirebaseConstants.messages)
            .document(fromUUID)
            .collection(toUUID)
            .document()
        
        let message = ["message": message, "fromUUID": fromUUID, "toUUID": toUUID, "timestamp": Timestamp()] as [String: Any]
        referenceSender.setData(message) { error in
            if error != nil {
                print("Errro sending de message ")
                return
            }
        }
        
        let referenceReceiver = dbFirestore.collection(FirebaseConstants.messages)
            .document(toUUID)
            .collection(fromUUID)
            .document()
        referenceReceiver.setData(message) { error in
            if error != nil {
                print("Error saving the message receiver")
                return
            }
            print(message)
        }
    }
}
