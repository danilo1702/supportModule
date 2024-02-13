//
//  ListArticlesModel.swift
//
//
//  Created by Danilo Hernandez on 30/10/23.
//

import Foundation


public struct InformationCardApi: Codable {
    
    public let id: String
    public let image: ImageModelApi?
    public let link: String?
    public let titleFormat: TextViewModelInfoApi
    public let dateFormat: TextViewModelInfoApi?
    public let designCard: ComponentDesignApi?
    public let action: String?
    public let type: String
    
    public init(id: String, image: ImageModelApi? = nil, link: String? = nil, titleFormat: TextViewModelInfoApi, dateFormat: TextViewModelInfoApi? = nil, designCard: ComponentDesignApi? = nil, action: String? = nil, type: String) {
        self.id = id
        self.image = image
        self.link = link
        self.titleFormat = titleFormat
        self.dateFormat = dateFormat
        self.designCard = designCard
        self.action = action
        self.type = type
    }
    public var imageUrl: URL?  {
        guard let image = image, let url = URL(string: image.image) else { return nil}
        return url
    }
}
public struct TextViewModelInfoApi: Codable {
    public let text: String
    public let fontSize: String
    public let foregroundColor: String
    public let expandable: Bool?
    
    public init(text: String, fontSize: String, foregroundColor: String, expandable: Bool? = false) {
        self.text = text
        self.fontSize = fontSize
        self.foregroundColor = foregroundColor
        self.expandable = expandable
    }
    

}
public struct ComponentDesignApi: Codable {
    
    public var backgroundColor: String?
    public var cornerRaiuds: String?
    public var colorSelected: String?
    
    public init(backgroundColor: String? = nil, cornerRaiuds: String? = nil, colorSelected: String? = nil) {
        self.backgroundColor = backgroundColor
        self.cornerRaiuds = cornerRaiuds
        self.colorSelected = colorSelected
    }
}
public struct ImageModelApi: Codable {
    public let image: String
    public let backgroundColor: String?
    
    public init(image: String, backgroundColor: String? = nil) {
        self.image = image
        self.backgroundColor = backgroundColor
    }
}

