//
//  CalificationDesignModel.swift
//
//
//  Created by Danilo Hernandez on 18/12/23.
//

import Foundation

public struct CalificationDesignModel: Codable {

        let mainTitle: TextViewModelInfoApi
        let companyLogo: String
        let secondTitle: TextViewModelInfoApi
        let star: Star
        let completeButton: ButtonDesignModel
    
    public init(mainTitle: TextViewModelInfoApi, companyLogo: String, secondTitle: TextViewModelInfoApi, star: Star, completeButton: ButtonDesignModel) {
        self.mainTitle = mainTitle
        self.companyLogo = companyLogo
        self.secondTitle = secondTitle
        self.star = star
        self.completeButton = completeButton
    }

}
public struct ButtonDesignModel: Codable {
    public let text: TextViewModelInfoApi
    public let backgroundColor: String
    
    public init(text: TextViewModelInfoApi, backgroundColor: String) {
        self.text = text
        self.backgroundColor = backgroundColor
    }
}

public struct Star: Codable {
    let sfImageFill, sfImage, foregroundColor: String
}
