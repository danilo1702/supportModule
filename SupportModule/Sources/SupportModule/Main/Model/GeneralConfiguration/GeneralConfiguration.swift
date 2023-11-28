//
//  GeneralConfiguration.swift
//
//
//  Created by Danilo Hernandez on 30/10/23.
//

import Foundation

public struct GeneralConfiguration  {
    
    public let buttonInformationStartChat: ButtonModel
    public let placeHolderSearchBar: String
    public let titleModule: TextViewModel
    public let titleLastChat: TextViewModel
    public let titleChatButton: String
    
    
    public init(buttonInformationStartChat: ButtonModel, placeHolderSearchBar: String, titleModule: TextViewModel, titleLastChat: TextViewModel, titleChatButton: String) {
        self.buttonInformationStartChat = buttonInformationStartChat
        self.placeHolderSearchBar = placeHolderSearchBar
        self.titleModule = titleModule
        self.titleLastChat = titleLastChat
        self.titleChatButton = titleChatButton
    }
}
