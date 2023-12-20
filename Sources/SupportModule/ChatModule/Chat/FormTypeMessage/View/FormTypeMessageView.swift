//
//  FormTypeMessageView.swift
//
//
//  Created by Danilo Hernandez on 20/12/23.
//

import SwiftUI

public struct FormTypeMessageView: View {
    
    @State var selectionType: OptionsMessageModel = OptionsMessageModel(text: "Seleccion unica")
    var arrayOptionsType = [OptionsMessageModel(text: "Seleccion unica"), OptionsMessageModel(text: "Multiple seleccion"), OptionsMessageModel(text: "Otra opcion")]
    @State public var saveOptions: [OptionsMessage] = []
    @State var arrayOptions: [TextFieldViewPersonalizedForm] = []
    @State var count: Int = 0
    
    public var body: some View {
        Form {
            Section {
                Picker("Tipo de mensaje", selection: $selectionType) {
                    ForEach(arrayOptionsType, id: \.self) {
                        Text($0.text)
                    }
                }.pickerStyle(.menu)
                
                if selectionType.text == TypeMessage.multipleChoice.rawValue || selectionType.text == TypeMessage.onChoice.rawValue {
                    
                    ForEach(arrayOptions, id: \.self) {
                        showOption(textField: $0)
                        
                    }
                    Button(action: {
                        arrayOptions.append(TextFieldViewPersonalizedForm(saveOption: $saveOptions))
                        saveOptions.forEach { option in
                            print(option.text)
                        }
                    }, label: {
                        Text("Agregar")
                    })
                }
                
                
            } header: {
                Text("Mensaje personalizado")
            }
            
        }
    }
    
    @ViewBuilder
    func showOption(textField: TextFieldViewPersonalizedForm) -> some View {
        if let position = saveOptions.firstIndex(where: {$0.id == "\(textField.id)"}){
            HStack {
                Text("Opción \(saveOptions[position].position):")
               textField
           }
        } else {
            HStack {
                Text("Opción \(arrayOptions.count):")
               textField
           }
        }
    }
}
