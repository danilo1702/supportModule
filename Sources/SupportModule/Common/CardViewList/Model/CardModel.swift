//
//  CardModel.swift
//  
//
//  Created by Danilo Hernandez on 27/10/23.
//

import Foundation
import SwiftUI

public struct CardModel: Identifiable {
    
    public var id: String
    public var image: ImageModel?
    public var link: String?
    public var uniqueId: UUID = UUID()
    public var titleFormat: TextViewModel
    public var dateFormat: TextViewModel?
    public var designCard: ComponentDesign
    public var action: String
    public var fromUUID: String?
    public var toUUID: String?
    
    
    public init(id: String, image: ImageModel? = nil, link: String? = nil, titleFormat: TextViewModel, dateFormat: TextViewModel? = nil, designCard: ComponentDesign = ComponentDesign(backgroundColor: .gray.opacity(0.1), cornerRaiuds: 15.0), fromUUID: String? = nil, toUUID: String? = nil, action: String = "") {
        self.id = id
        self.image = image
        self.link = link
        self.titleFormat = titleFormat
        self.dateFormat = dateFormat
        self.designCard = designCard
        self.fromUUID = fromUUID
        self.toUUID = toUUID
        self.action = action
    }
    
    public var imageUrl: URL?  {
        guard let image = image, let url = URL(string: image.image) else { return nil}
        return url
    }
}

public struct ImageModel {
    public let image: String
    public let backgroundColor: Color?
    
    public init(image: String, backgroundColor: Color? = nil) {
        self.image = image
        self.backgroundColor = backgroundColor
    }
}

public struct ComponentDesign {
    
    public var backgroundColor: Color
    public var cornerRaiuds: CGFloat
    
    public init(backgroundColor: Color, cornerRaiuds: CGFloat) {
        self.backgroundColor = backgroundColor
        self.cornerRaiuds = cornerRaiuds
    }
}



