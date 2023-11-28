//
//  MessagesStruct.swift
//
//
//  Created by Danilo Hernandez on 31/10/23.
//

import Foundation

struct MessagesStruct: Identifiable {
    
    public var uiniqueId: UUID = UUID()
    public var id: String
    public var linkImage: String?
    public var message: TextViewModel?
    public var date: TextViewModel
    public var receive: Bool
    public var specialMessage: SpecialMessage?
    
    public init(id: String, linkImage: String? = nil, message: TextViewModel? = nil, date: TextViewModel, receive: Bool, specialMessage: SpecialMessage? = nil) {
        self.id = id
        self.linkImage = linkImage
        self.message = message
        self.date = date
        self.receive = receive
        self.specialMessage = specialMessage
    }
    
}
