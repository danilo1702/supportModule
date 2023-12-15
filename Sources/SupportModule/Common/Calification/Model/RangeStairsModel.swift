//
//  RangeStairsModel.swift
//  
//
//  Created by Danilo Hernandez on 14/12/23.
//

import Foundation

public struct RangeStairsModel: Identifiable {
    public var id: UUID = UUID()
    var position: Int
    var status: Bool
}

public struct OptionSelected: Codable {
    
    let id: String
    let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

public struct SendCalification: Codable {
    let id: UUID = UUID()
    let stairs: Int
    let finished: Bool
    let qualified: Bool
    let valoration: OptionSelected
    let comment: String?
    
    public init(stairs: Int, finished: Bool, qualified: Bool, valoration: OptionSelected, comment: String? = nil) {
        self.stairs = stairs
        self.finished = finished
        self.qualified = qualified
        self.valoration = valoration
        self.comment = comment
    }
}
