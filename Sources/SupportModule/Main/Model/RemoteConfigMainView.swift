//
//  RemoteConfigMainView.swift
//
//
//  Created by Danilo Hernandez on 19/12/23.
//

import Foundation

public struct RemoteConfigModelMainView: Codable {
    let colorbackgroundImage: String
    let mainTitle: TextViewModelInfoApi
    let searchBar: SearchBarModel
    
    public init(colorbackgroundImage: String, mainTitle: TextViewModelInfoApi, searchBar: SearchBarModel) {
        self.colorbackgroundImage = colorbackgroundImage
        self.mainTitle = mainTitle
        self.searchBar = searchBar
    }
}

public struct SearchBarModel: Codable {
    let backgroundColor: String
    let placeHolder: TextViewModelInfoApi
    
    public init(backgroundColor: String, placeHolder: TextViewModelInfoApi) {
        self.backgroundColor = backgroundColor
        self.placeHolder = placeHolder
    }
}



public struct ActivateFeatures: Codable {
    let searchArticles: Bool
    let chat: Bool
    let turns: Bool
    
    public init(searchArticles: Bool, chat: Bool, turns: Bool) {
        self.searchArticles = searchArticles
        self.chat = chat
        self.turns = turns
    }
}
