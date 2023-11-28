//
//  PersonalInformationUser.swift
//
//
//  Created by Danilo Hernandez on 22/11/23.
//

import Foundation
import FirebaseFirestore

struct PersonalInformationUser: Codable {
    
    let email: String
    let uuid: String
    let name: String?
    @ServerTimestamp var createdAt: Timestamp?
    
    init(email: String, uuid: String, name: String? = nil, createdAt: Timestamp? = nil) {
        self.email = email
        self.uuid = uuid
        self.name = name
        self.createdAt = createdAt
    }
}
