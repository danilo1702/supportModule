//
//  PersonalInformationUser.swift
//
//
//  Created by Danilo Hernandez on 22/11/23.
//

import Foundation
import FirebaseFirestore

public struct PersonalInformationUser: Codable {
    
    public let email: String
    public let uuid: String
    public let name: String
    @ServerTimestamp public var createdAt: Timestamp?
    
    public init(email: String, uuid: String, name: String, createdAt: Timestamp? = nil) {
        self.email = email
        self.uuid = uuid
        self.name = name
        self.createdAt = createdAt
    }
}
