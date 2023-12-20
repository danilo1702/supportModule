//
//  OptionsMessage.swift
//
//
//  Created by Danilo Hernandez on 20/12/23.
//

import Foundation

public struct OptionsMessage {
    public var id: String
    public var text: String
    public var position: Int
    
    public init(id: String, text: String, position: Int) {
        self.id = id
        self.text = text
        self.position = position
    }
}
