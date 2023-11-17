//
//  UIComponent.swift
//
//
//  Created by Danilo Hernandez on 15/11/23.
//

import Foundation

public protocol UIComponent: Hashable {
    var meta: DVMetaData  { get set}
    var uniqueId: UUID { get }
    //func render(mainView: MainView) -> AnyView
}
