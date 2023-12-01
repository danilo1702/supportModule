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
    var supportInfo: MessageModel
    var toUUID: String
    @Published var messages: [MessageModel] = []
    @Published var count: Int = 0
    
    public init(supportInfo: MessageModel) {
        let fromUUID = Auth.auth().currentUser?.uid
        let toUUID = fromUUID != nil ? fromUUID == supportInfo.fromUUID ? supportInfo.toUUID : supportInfo.fromUUID : ""
        self.supportInfo = supportInfo
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
                    }else {
                        print("Error decoding *//*-/*-*-/-*/-/**-/*-/")
                    }
                }
            }
            DispatchQueue.main.async {
                self.count += 1
            }
        }
    }

    func sendMessage(message: String) {
        
        guard let fromUUID = Auth.auth().currentUser?.uid else { return }
        let referenceSender = dbFirestore.collection(FirebaseConstants.messages)
            .document(fromUUID)
            .collection(toUUID)
            .document()
        
        let message = ["message": message, "fromUUID": fromUUID, "toUUID": toUUID, "timestamp": Timestamp(), "fromName": UIDevice.modelName] as [String: Any]
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
        DispatchQueue.main.async {
            self.count += 1
        }
        saveLastMessage(toUUID: toUUID, message: message)
    }
    func saveLastMessage(toUUID: String, message: [String: Any]) {
        guard let fromUUID = Auth.auth().currentUser?.uid else { return }
        
        let senderReference = dbFirestore.collection(FirebaseConstants.lastMessages)
            .document(fromUUID)
            .collection(FirebaseConstants.messages)
            .document(toUUID)
        
        let receiverReference = dbFirestore.collection(FirebaseConstants.lastMessages)
            .document(toUUID)
            .collection(FirebaseConstants.messages)
            .document(fromUUID)
        
        let batch = dbFirestore.batch()
        
        batch.setData(message, forDocument: senderReference)
        batch.setData(message, forDocument: receiverReference)
        
        batch.commit { error in
            if let error = error {
                print("Error saving last message: \(error.localizedDescription)")
            } else {
                print("Last message saved successfully")
            }
        }
    }
}
