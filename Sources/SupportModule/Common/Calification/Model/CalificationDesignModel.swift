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
    let shadowOptions: Int
    let completeButton: ButtonDesignModel
    
    
    public init(mainTitle: TextViewModelInfoApi, companyLogo: String, secondTitle: TextViewModelInfoApi, star: Star, shadowOptions: Int, completeButton: ButtonDesignModel) {
        self.mainTitle = mainTitle
        self.companyLogo = companyLogo
        self.secondTitle = secondTitle
        self.star = star
        self.shadowOptions = shadowOptions
        self.completeButton = completeButton
    }
    
    enum CodingKeys: CodingKey {
        case mainTitle
        case companyLogo
        case secondTitle
        case star
        case shadowOptions
        case completeButton
    }

}
public struct ButtonDesignModel: Codable {
    public let text: TextViewModelInfoApi
    public let backgroundColor: String
    
    public init(text: TextViewModelInfoApi, backgroundColor: String) {
        self.text = text
        self.backgroundColor = backgroundColor
    }
    
    enum CodingKeys: CodingKey {
        case text
        case backgroundColor
    }
}

public struct Star: Codable {
    
    let sfImageFill, sfImage, foregroundColor: String
    
    public init(sfImageFill: String, sfImage: String, foregroundColor: String) {
        self.sfImageFill = sfImageFill
        self.sfImage = sfImage
        self.foregroundColor = foregroundColor
    }
    enum CodingKeys: CodingKey {
        case sfImageFill
        case sfImage
        case foregroundColor
    }
}
