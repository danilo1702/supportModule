//
//  TextFieldViewPersonalizedForm.swift
//
//
//  Created by Danilo Hernandez on 20/12/23.
//

import SwiftUI

public struct TextFieldViewPersonalizedForm: View, Hashable {
    
    @Binding public var saveOption: [OptionsMessage]
    public var id: UUID = UUID()
    @State public var text: String = ""
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public static func == (lhs: TextFieldViewPersonalizedForm, rhs: TextFieldViewPersonalizedForm) -> Bool {
        lhs.id == rhs.id
    }
    public var body: some View {
        TextField("Ingresa aqui", text: $text)
            .onChange(of: text, perform: { value in
                insertOption()
                
            })
    }
    func insertOption() {
        if let index = saveOption.firstIndex(where: {$0.id == "\(id)"}), !text.isEmpty {
            saveOption.remove(at: index)
            saveOption.insert(OptionsMessage(id: "\(id)", text: text), at: index)
        } else if !text.isEmpty{
            saveOption.append(OptionsMessage(id: "\(id)", text: text))
        }
    }
    
}
