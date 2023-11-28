//
//  TextViewModel.swift
//
//
//  Created by Danilo Hernandez on 27/10/23.
//

import Foundation
import SwiftUI

public struct TextViewModel {
    
    public var text: String
    public var foregroundColor: Color
    public var font: Font
    public var expandable: Bool
    
    
    public init(text: String, foregroundColor: Color = .black, font: Font = .system(size: 15), expandable: Bool = false) {
        
        self.foregroundColor = foregroundColor
        self.font = font
        self.text = text
        self.expandable = expandable
    }
}
