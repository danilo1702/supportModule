//
//  FormTypeMessageViewModel.swift
//
//
//  Created by Danilo Hernandez on 20/12/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

public class FormTypeMessageViewModel: ObservableObject {
    public var toUUID: String
    public init (toUUID: String) {
        self.toUUID = toUUID
    }
    func sendMessage(message: String, type: String, options: [OptionsMessage], completion: @escaping (Result<Bool, Never>) -> ()) {
        var optionsToSend : [[String: Any]] = []
        guard let fromUUID = FirebaseManagerData.initialization.dbAuth.currentUser?.uid else { return }
        
        let referenceSender = FirebaseManagerData.initialization.dbFirestore.collection(FirebaseConstants.messages)
            .document(fromUUID)
            .collection(toUUID)
            .document()
        if options.count > 0, let firstOption = options.first, let lines = firstOption.lines {
            optionsToSend = [["id": firstOption.id, "lines": lines]]
        } else {
           
            optionsToSend = options.map { option  in
                guard let text = option.text, let position = option.position else { return [:]}
                return ["id": option.id, "text": text, "position": position]
            }
        }
        
        var message = [FirebaseConstants.message: message, FirebaseConstants.fromUUID: fromUUID, FirebaseConstants.toUUID: toUUID, FirebaseConstants.timestamp: Timestamp(), FirebaseConstants.fromName: UIDevice.modelName, "type": type, "options": optionsToSend] as [String: Any]
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
            self.saveLastMessage(fromUUID: fromUUID, message: &message)
        }
        completion(.success(true))
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
