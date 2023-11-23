//
//  MessageModel.swift
//
//
//  Created by Danilo Hernandez on 23/11/23.
//

import Foundation
import FirebaseFirestore

public struct MessageModel: Codable, Identifiable {
    public var id: UUID = UUID()
    let message: String
    let fromUUID: String
    let toUUID: String
    let timestamp: Timestamp
    
}
