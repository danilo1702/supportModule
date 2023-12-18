//
//  ChatViewModel.swift
//
//
//  Created by Danilo Hernandez on 23/11/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine


class ChatViewModel: ObservableObject {
    var toUUID: String
    @Published var messages: [MessageModel] = []
    @Published var count: Int = 0
    @Published var finishedChat: Bool = false
    @Published var qualified: Bool = false
    
    public init(toUUID: String) {
        self.toUUID = toUUID
    }
    
    func fetchingMessages() {
        
        guard let fromUUID = FirebaseManagerData.initialization.dbAuth.currentUser?.uid else { return }
        
        let reference = FirebaseManagerData.initialization.dbFirestore.collection(FirebaseConstants.messages)
            .document(fromUUID)
            .collection(toUUID)
            .order(by: FirebaseConstants.timestamp)
        
        reference.addSnapshotListener { documentSnapshot, error in
            guard let documentSnapshot = documentSnapshot, error == nil else { return }
            
            documentSnapshot.documentChanges.forEach { change in
                if change.type == .added {
                    
                
                    if let cm = try? change.document.data(as: MessageModel.self) {
                        self.messages.append(cm)
                        print("Appending chatMessage in Chat")
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

    func finishChat() {
        guard let uuid = FirebaseManagerData.initialization.dbAuth.currentUser?.uid else { return }
        let reference = FirebaseManagerData.initialization.dbFirestore.collection("closedChats").document(uuid).collection(FirebaseConstants.messages)
            .document(toUUID)
        
        reference.setData(["finished": false, "qualified": false])
    }
    func addFinishChatButton() -> Bool{
        var result: Bool = false
        guard let uuid = FirebaseManagerData.initialization.dbAuth.currentUser?.uid else { return result }
        let reference = FirebaseManagerData.initialization.dbFirestore.collection(FirebaseConstants.supports)
        
        reference.whereField("uuid", isEqualTo: uuid).getDocuments { documentSnapshot, error in
          guard  let _ = documentSnapshot, error == nil else{ return  }
            result = true
        }
        return result
    }
    func chatStatus() {
        guard let uuid = FirebaseManagerData.initialization.dbAuth.currentUser?.uid else { return }
        
        let reference = FirebaseManagerData.initialization.dbFirestore.collection(FirebaseConstants.closedChats).document(uuid).collection(FirebaseConstants.messages).document(toUUID)

        reference.addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self, let document = documentSnapshot, error == nil else{ return }
            
                if let status = try? document.data(as: ChatStatusModel.self) {
                    self.finishedChat = status.finished
                    self.qualified = !status.qualified
                }
        }
    }
    
    func sendMessage(message: String) {
        
        guard let fromUUID = FirebaseManagerData.initialization.dbAuth.currentUser?.uid else { return }
        
        
        let referenceSender = FirebaseManagerData.initialization.dbFirestore.collection(FirebaseConstants.messages)
            .document(fromUUID)
            .collection(toUUID)
            .document()
        
        var message = ["message": message, "fromUUID": fromUUID, "toUUID": toUUID, "timestamp": Timestamp(), "fromName": UIDevice.modelName] as [String: Any]
        referenceSender.setData(message) { error in
            if error != nil {
                print("Errro sending de message ")
                return
            }
        }
        
        let referenceReceiver = FirebaseManagerData.initialization.dbFirestore.collection(FirebaseConstants.messages)
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
           
            self.saveLastMessage(fromUUID: fromUUID, message: &message)
        }
    }
    
    func saveLastMessage(fromUUID: String, message: inout [String: Any]) {
        
        
        var messageReceiver = message
        messageReceiver [FirebaseConstants.messageRead] = true
        let senderReference = FirebaseManagerData.initialization.dbFirestore.collection(FirebaseConstants.lastMessages)
           .document(fromUUID)
            .collection(FirebaseConstants.messages)
            .document(toUUID)

        let receiverReference = FirebaseManagerData.initialization.dbFirestore.collection(FirebaseConstants.lastMessages)
            .document(toUUID)
            .collection(FirebaseConstants.messages)
            .document(fromUUID)

        let batch = FirebaseManagerData.initialization.dbFirestore.batch()
        
        batch.setData(message, forDocument: senderReference)
        batch.setData(messageReceiver, forDocument: receiverReference)
        
        batch.commit { error in
            if let error = error {
                print("Error saving last message: \(error.localizedDescription)")
            } else {
                print("Last message saved successfully")
            }
        }
    }
}
