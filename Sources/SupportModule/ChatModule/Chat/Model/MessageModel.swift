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
    let timestamp: Timestamp
    let name: String

}
