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
    public let name: String?
    @ServerTimestamp public var createdAt: Timestamp?
    
}
