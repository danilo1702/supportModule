//
//  File.swift
//  
//
//  Created by Danilo Hernandez on 31/10/23.
//

import Foundation

struct QueryTypesModel: Identifiable {
    
    let uniqueId: UUID = UUID()
    let id: String
    let title: TextViewModel
    
    public init(id: String, title: TextViewModel) {
        self.id = id
        self.title = title
    }
}
