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
    @StateObject var viewModel: FormTypeMessageViewModel
    @State var text: String = ""
    public init (toUUID: String) {
        self._viewModel = StateObject(wrappedValue: FormTypeMessageViewModel(toUUID: toUUID))
    }
    public var body: some View {
        Form {
            Section {
                Picker("Tipo de mensaje", selection: $selectionType) {
                    ForEach(arrayOptionsType, id: \.self) {
                        Text($0.text)
                    }
                }.pickerStyle(.menu)
                
                VStack{
                    TextField("Mensaje", text: $text)
                        .padding()
                        .background(.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(radius: 15)
                    if selectionType.text == TypeMessage.multipleChoice.rawValue || selectionType.text == TypeMessage.onChoice.rawValue {
                        
                        ForEach(arrayOptions, id: \.self) { textField in
                            HStack {
                                Text("Opción \(showOption(textField: textField)):")
                                textField
                            }
                        }
                        Button(action: {
                            arrayOptions.append(TextFieldViewPersonalizedForm(saveOption: $saveOptions))
                            saveOptions.forEach { option in
                                print(option.text)
                            }
                        }, label: {
                            Text("Añadir opción").padding()
                        })
                        Button(action: {
                            viewModel.sendMessage(message: text, type: TypeMessage.onChoice.rawValue, options: saveOptions)
                        }, label: {
                            Text("Enviar mensaje").foregroundColor(.white)
                        }).padding()
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
            } header: {
                Text("Mensaje personalizado")
            }
        }
    }
    
  
    func showOption(textField: TextFieldViewPersonalizedForm) -> Int {
        if let position = saveOptions.firstIndex(where: {$0.id == "\(textField.id)"}){
            saveOptions[position].position
        } else {
            arrayOptions.count
        }
    }
}
