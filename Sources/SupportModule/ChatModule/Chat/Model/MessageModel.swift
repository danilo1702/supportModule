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
    let messageRead: Bool?
    let type: String
    let options: [OptionsMessageModel]?
    
    public init(id: String? = nil, message: String, fromUUID: String, toUUID: String, timestamp: Timestamp? = nil, fromName: String, messageRead: Bool? = false, type: String, options: [OptionsMessageModel]? = nil) {
        self.id = id
        self.message = message
        self.fromUUID = fromUUID
        self.toUUID = toUUID
        self.timestamp = timestamp
        self.fromName = fromName
        self.messageRead = messageRead
        self.type = type
        self.options = options
    }
    enum CodingKeys: CodingKey {
        case id
        case message
        case fromUUID
        case toUUID
        case timestamp
        case fromName
        case messageRead
        case type
        case options
    }
}

public struct OptionsMessageModel: Codable, Hashable {
    
    var id: UUID = UUID()
    let text: String
    public init(text: String) {
        self.text = text
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public static func == (lhs: OptionsMessageModel, rhs: OptionsMessageModel) -> Bool {
        return lhs.id == rhs.id
        }
}
