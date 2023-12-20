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
    
    public init(id: String, text: String) {
        self.id = id
        self.text = text
    }
}
