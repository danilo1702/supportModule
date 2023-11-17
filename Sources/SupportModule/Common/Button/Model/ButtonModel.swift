//
//  ButtonModel.swift
//
//
//  Created by Danilo Hernandez on 31/10/23.
//

import SwiftUI

public struct ButtonModel {
    

    public let designButton: ComponentDesign
    public let image: Image?
    public let title: TextViewModel
    
    
    public init(image: Image? = nil, designButton: ComponentDesign, title: TextViewModel) {
        self.title = title
        self.image = image
        self.designButton = designButton
    }
}

