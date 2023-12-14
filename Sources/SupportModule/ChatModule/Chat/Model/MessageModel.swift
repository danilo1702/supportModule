//
//  MessageModel.swift
//
//
//  Created by Danilo Hernandez on 23/11/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct MessageModel: Codable, Identifiable {
    
    public var uniqueID: UUID = UUID()
    @DocumentID public var id: String?
    let message: String
    let fromUUID: String
    let toUUID: String
    let timestamp: Timestamp?
    let fromName: String
    var messageRead: Bool?
    
    public init(id: String? = nil, message: String, fromUUID: String, toUUID: String, timestamp: Timestamp? = nil, fromName: String, messageRead: Bool? = false) {
        self.id = id
        self.message = message
        self.fromUUID = fromUUID
        self.toUUID = toUUID
        self.timestamp = timestamp
        self.fromName = fromName
        self.messageRead = messageRead
    }
    enum CodingKeys: CodingKey {
        case id
        case message
        case fromUUID
        case toUUID
        case timestamp
        case fromName
    }

}
