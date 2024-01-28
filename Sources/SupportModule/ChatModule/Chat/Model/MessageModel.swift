//
//  MessageModel.swift
//
//
//  Created by Danilo Hernandez on 23/11/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import Drawing
import SwiftUI

public struct MessageModel: Codable, Identifiable {
    
    public var uniqueID: UUID = UUID()
    @DocumentID public var id: String?
    let message: String
    let fromUUID: String
    let toUUID: String
    let timestamp: Timestamp?
    let fromName: String
    let messageRead: Bool?
    let type: String
    let options: [OptionsMessageModel]?
    
    public init(id: String? = nil, message: String, fromUUID: String, toUUID: String, timestamp: Timestamp? = nil, fromName: String, messageRead: Bool? = false, type: String, options: [OptionsMessageModel]? = nil) {
        self.id = id
        self.message = message
        self.fromUUID = fromUUID
        self.toUUID = toUUID
        self.timestamp = timestamp
        self.fromName = fromName
        self.messageRead = messageRead
        self.type = type
        self.options = options
    }
    enum CodingKeys: CodingKey {
        case id
        case message
        case fromUUID
        case toUUID
        case timestamp
        case fromName
        case messageRead
        case type
        case options
    }
}

public struct OptionsMessageModel: Codable, Hashable {
    
    var id: UUID = UUID()
    let text: String
    let lines: linesModelDrwApi?
    
    public init(text: String, lines: linesModelDrwApi? = nil) {
        self.text = text
        self.lines = lines
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public static func == (lhs: OptionsMessageModel, rhs: OptionsMessageModel) -> Bool {
        return lhs.id == rhs.id
        }
}

public struct linesModelDrwApi: Codable {
    public var points: [PointsLineApi]
    public var color: String
    public var lineWidth: Double
    public init(points: [PointsLineApi], color: String, lineWidth: Double) {
        self.points = points
        self.color = color
        self.lineWidth = lineWidth
    }
}
public struct PointsLineApi: Codable {
    public var x: Double
    public var y: Double
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

