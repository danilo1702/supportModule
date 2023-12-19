//
//  StructModel.swift
//  
//
//  Created by Danilo Hernandez on 15/11/23.
//

import Foundation
import SwiftUI

public struct DVFormContent {
    let header: DVHeader
    let fields: DVContentData
    let footer: DVFooter
}

struct DVHeader {
    
    let title: String
    let previousPage: Int?
    let currentPage: Int?
    let nextPage: Int
    let lastPage: Bool
    let continueVoucher: Bool
    
    public init(title: String, previousPage: Int, currentPage: Int, nextPage: Int, lastPage: Bool, continueVoucher: Bool) {
        self.title = title
        self.previousPage = previousPage
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.lastPage = lastPage
        self.continueVoucher = continueVoucher
    }
    
}

struct DVFooter {
    
    let buttons: [DVContentData]
    
    init(buttons: [DVContentData]) {
        self.buttons = buttons
    }
}

public struct DVContentData{
    
    public let backgroundPage: ColorData?
    public let row: [Row]
    
    public init(backgroundPage: ColorData? = nil, row: [Row]) {
        self.backgroundPage = backgroundPage
        self.row = row
    }
    
}

public struct ColorData {
    public let color: String
    public let opacity: String?
    public init(color: String, opacity: String?) {
        self.color = color
        self.opacity = opacity
    }
    
    public var showColor: Color {
        return Color(hex: color).opacity(Double(opacity ?? "1.0")!)
    }
}

public struct Row{
    public let columns: [Fields]
    public init(columns: [Fields]) {
        self.columns = columns
    }
}
public struct Fields: Identifiable {
    public var identifiableId: UUID = UUID()
    public let type: String
    public let name: String
    public let id: String
    public let required: Bool
    public let value: String?
    public let position: String
    public let metaData: DVMetaData
    
    public init(type: String, name: String, id: String, required: Bool, value: String?, position: String, metaData: DVMetaData) {
        self.type = type
        self.name = name
        self.id = id
        self.required = required
        self.value = value
        self.position = position
        self.metaData = metaData
    }
    
    public var positionComponent:  PositionEnum {
        return PositionEnum.getPosition(from: position)
    }
}

struct PageInformation {
    var titlePage: String
    var nextPage: Int
    var isLastPage: Bool
    var providerId: String?
    var continueVoucher: Bool
}
public struct ParametersNewPage: Codable {
    
    var paramId: String
    var value: String
    
    enum CodingKeys:  String, CodingKey {
        case paramId = "paramID"
        case value
    }
    
   public init (paramId: String, value: String) {
        self.paramId = paramId
        self.value = value
    }
}
public struct DVMetaData {
    
    public var uniqueId = UUID()
    public var id: String?
    public var label: String?
    public var placeholder: String?
    public var saveField: Bool?
    public var options: [OptionItemModelV2]?
    public var reguex: [String]?
    public var condition: [ConditionComponent]?
    public var keyboardType: String?
    public var cornerRadius: Float?
    public var lineLimit: Int?
    public var opacityColorDouble: Double?
    public var textColor: String?
    public var maskType: String?
    public var alignment: AlignmentType?
    public var padding: DFPadding?
    public var bold: Bool?
    public var fontSize:CGFloat?
    public var isRequired: Bool?
    public var name: String?
    public var value: String?
    public var additionalInfo: AdditionalInfo?
    
    public init(id: String? = nil,
                label: String? = nil,
                placeholder: String? = nil,
                saveField: Bool? = false,
                options: [OptionItemModelV2]? = nil,
                reguex: [String]? = nil,
                condition: [ConditionComponent]? = nil,
                keyboardType: String? = nil,
                cornerRadius: Float? = nil,
                lineLimit: Int? = nil,
                opacityColorDouble: Double? = nil,
                textColor: String? = nil,
                maskType: String? = nil,
                alignment: AlignmentType? = nil,
                padding: DFPadding? = nil,
                bold: Bool? = nil,
                fontSize: CGFloat? = nil,
                isRequired: Bool? = nil,
                name: String? = nil,
                value: String? = nil, additionalInfo: AdditionalInfo? = nil) {
        self.id = id
        self.label = label
        self.placeholder = placeholder
        self.options = options
        self.reguex = reguex
        self.condition = condition
        self.keyboardType = keyboardType
        self.cornerRadius = cornerRadius
        self.lineLimit = lineLimit
        self.opacityColorDouble = opacityColorDouble
        self.textColor = textColor
        self.maskType = maskType
        self.alignment = alignment
        self.padding = padding
        self.bold = bold
        self.fontSize = fontSize
        self.isRequired = isRequired
        self.name = name
        self.value = value
        self.additionalInfo = additionalInfo
    }
    
    public var mask: String? {
        if let mask = maskType {
            return getTypeMask(mask)
        } else {
            return nil
        }
    }
}

public struct AdditionalInfo  {
    
    public var bold: Bool
    public var color: String
    public var fontSize: String
    public var paddingLeft: String?
    public var paddingRight: String?
    public var paddingBottom: String?
    public var paddingTop: String?
    public var textAlign: String
    public var background: String?
    public var backgroundDisable: String?
    public var textColor: String?
    public var action: String?
    public var cornerRadius: String?
    public var backgroundBorder: String?
    

    public init(bold: Bool, color: String, fontSize: String, paddingTop: String? = nil, paddingBottom: String? = nil ,paddingLeft: String? = nil, paddingRight: String? = nil , textAlign: String, action: String? = nil, background: String? = nil , backgroundDisable: String? = nil, backgroundBorder: String? = nil, textColor: String? = nil, cornerRadius: String? = nil) {
        self.bold = bold
        self.color = color
        self.fontSize = fontSize
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
        self.paddingLeft = paddingLeft
        self.paddingRight = paddingRight
        self.textAlign = textAlign
        self.action = action
        self.background = background
        self.backgroundDisable = backgroundDisable
        self.textColor = textColor
        self.cornerRadius = cornerRadius
    }
    
    public var backgroundBorderColor: Color? {
        return Color(hex: backgroundBorder ?? "2C8A9E" )
    }
    public var backgroundColor: Color? {
        return Color(hex: background ?? "2C8A9E" )
    }
    public var backgroundDisableColor: Color? {
        return Color(hex: backgroundDisable ?? "C4C4C4")
    }
    public var textColorUI: Color? {
        return Color(hex: textColor ?? "FFFFFF")
    }
    
    public var cornerRadiusCGFloat: CGFloat {
        if let number = NumberFormatter().number(from: cornerRadius ?? "14") {
            let size = CGFloat(truncating: number)
            return size
        } else {
            return 0.0
        }
    }
    public var paddingTopCGFloat: CGFloat {
        if let number = NumberFormatter().number(from: paddingTop ?? "0.0") {
            let size = CGFloat(truncating: number)
            return size
        } else {
            return 0.0
        }
    }
    
    public var paddingBottomCGFloat: CGFloat {
        if let number = NumberFormatter().number(from: paddingBottom ?? "0.0") {
            let size = CGFloat(truncating: number)
            return size
        } else {
            return 0.0
        }
    }
    
    public var paddingLeftCGFloat: CGFloat {
        if let number = NumberFormatter().number(from: paddingLeft ?? "0.0") {
            let size = CGFloat(truncating: number)
            return size
        } else {
            return 16
        }
    }
    
    public var paddingRightCGFloat: CGFloat {
        if let number = NumberFormatter().number(from: paddingRight ?? "0.0") {
            let size = CGFloat(truncating: number)
            return size
        } else {
            return 0.0
        }
    }
    public var paddingEdge: EdgeInsets {
        return EdgeInsets(top: paddingTopCGFloat, leading: paddingLeftCGFloat, bottom: paddingBottomCGFloat, trailing: paddingRightCGFloat)
    }
    
    public var fontSizeCGFloat: CGFloat {
        if let number = NumberFormatter().number(from: fontSize) {
            let size = CGFloat(truncating: number)
            return size
        } else {
            return 14.0
        }
    }
}

public struct ConditionComponent {
    
    public var id: String
    public var operador: String
    public var value : String?
    
    public init(id: String, operador: String, value: String? = nil) {
        self.id = id
        self.operador = operador
        self.value = value
    }
    
    public enum CodingKeys: String, CodingKey {
        case operador = "operator"
        case id
        case value
    }
}


//TO REQUEST

public struct ContentDataRequest {
    var content: ContentRequest
    
    public init(content: ContentRequest) {
        self.content = content
    }
}

public struct ContentRequest {
    
    
    var page: Int
    var providerId: String
    public init(page: Int, providerId: String) {
        self.page = page
        self.providerId = providerId
    }
    enum CodingKeys: String, CodingKey {
        case providerId = "providerID"
        case page
    }
}

public struct OptionItemModel: Hashable, Identifiable {
    
    public var uiniqueId = UUID()
    public var id: Int
    public var value: String
    public var label: String
    public var isSelected: Bool
    
    public init(id: Int, value: String, label: String, isSelected: Bool = false) {
        self.id = id
        self.value = value
        self.label = label
        self.isSelected = isSelected
    }
}

public struct OptionItemModelV2: Hashable {
    
    public var uiniqueId = UUID()
    public var value: String
    public var label: String
    public var foregroundColor: String
    public var isSelected: Bool
    
    public init(value: String, label: String, foregroundColor: String, isSelected: Bool = false) {
        self.value = value
        self.label = label
        self.foregroundColor = foregroundColor
        self.isSelected = isSelected
    }
}

public struct OptionItemModelAccount: Hashable {
    
    public var uiniqueId = UUID()
    public var value: String
    public var label: String
    public var label2: String
    public var availableBalance: String
    public var isSelected: Bool
    
    public init(value: String, label: String, label2: String, availableBalance: String, isSelected: Bool = false) {
        self.value = value
        self.label = label
        self.label2 = label2
        self.availableBalance = availableBalance
        self.isSelected = isSelected
    }
}

public enum PositionEnum: Comparable {
    case left
    case center
    case right
    
    public static func getPosition(from position: String) -> Self {
        switch position {
                
            case "left":
                return .left
            case "center":
                return .center
            case "right":
                return .right
            default:
                return .center
        }
    }
}

public enum AlignmentType: String, Codable {
    case top, bottom, left, right, center
}
public extension Alignment {
    
    static func getAlignmet(textAlign: String) -> Alignment {
        
        switch textAlign {
            case  "Center":
                return .center
            case  "left":
                return .leading
            case  "right":
                return .trailing
            default:
                return .center
        }
    }
    
}
public extension TextAlignment {
     
    static func getAlignmet(textAlign: String) -> TextAlignment {
        switch textAlign {
            case  "center":
                return .center
            case  "left":
                return .leading
            case  "right":
                return .trailing
            default:
                return .center
        }
    }
}
public struct DFPadding {
    
    public var left: CGFloat?
    public var right: CGFloat?
    public var top: CGFloat?
    public var bottom: CGFloat?
    
    public init(left: CGFloat? = 0, right: CGFloat? = 0, top: CGFloat? = 0, bottom: CGFloat? = 0) {
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
    }
}

public func getTypeMask(_ mask: String) -> String {
    switch mask {
        case "PHONE":
            return "XXXX XXXX"
        case "TEXT":
            return ""
        default:
            return ""
    }
}


