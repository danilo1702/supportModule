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
    @ServerTimestamp var createdAt: Timestamp?
}
