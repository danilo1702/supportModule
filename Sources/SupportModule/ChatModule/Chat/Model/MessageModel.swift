//
//  MessageModel.swift
//
//
//  Created by Danilo Hernandez on 23/11/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct MessageModel: Codable {
    @DocumentID var id: String?
    let message: String
    let fromUUID: String
    let toUUID: String
    let fromName: String?
    let timestamp: Timestamp
    
    
    public init(id: String? = nil, message: String, fromUUID: String, toUUID: String, fromName: String? = nil, timestamp: Timestamp) {
        self.id = id
        self.message = message
        self.fromUUID = fromUUID
        self.toUUID = toUUID
        self.fromName = fromName
        self.timestamp = timestamp
    }
    
}
