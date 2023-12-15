//
//  Extension+InformationCardApi.swift
//
//
//  Created by Danilo Hernandez on 15/12/23.
//

import SwiftUI

public extension InformationCardApi {
    func convertToCardModel() -> CardModel {
        return (CardModel(id: self.id , image: ImageModel(image: self.image?.image ?? "", backgroundColor: Color(hex: self.image?.backgroundColor ?? "")), link: self.link, titleFormat: TextViewModel(text: self.titleFormat.text, foregroundColor: Color(hex: self.titleFormat.foregroundColor), font: Font.system(size: self.titleFormat.fontSize.parseToCGFloat()), expandable: self.titleFormat.expandable ?? false), dateFormat: TextViewModel(text: self.dateFormat?.text ?? "", foregroundColor: Color(hex: self.dateFormat?.foregroundColor ?? "#000000"), font: Font.system(size: self.dateFormat?.fontSize.parseToCGFloat() ?? 0), expandable: self.dateFormat?.expandable ?? false) , designCard: ComponentDesign(backgroundColor: Color(hex: self.designCard?.backgroundColor ?? "#DAF1F0"), cornerRaiuds: self.designCard?.cornerRaiuds?.parseToCGFloat() ?? 15), action: self.action ?? ""))
        }
}
