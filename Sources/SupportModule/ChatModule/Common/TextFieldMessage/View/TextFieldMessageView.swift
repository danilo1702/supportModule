//
//  TextFieldMessage.swift
//
//
//  Created by Danilo Hernandez on 8/11/23.
//

import SwiftUI

public struct TextFieldMessageView: View {
    @State public var textToSend: String = ""
    public var completion: (_ text: String)->()

    public var body: some View {
        
        HStack(alignment: .bottom){
            
            Button(action: {}, label: {
                Image(systemName: "photo.badge.plus.fill")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.07, height: UIScreen.main.bounds.width * 0.07, alignment: .bottomLeading)
                    .foregroundStyle(.blue)
            })
            
                TextEditor(text: $textToSend)
                    .frame(minHeight: 35)
                    .fixedSize(horizontal: false, vertical: true)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                if textToSend.isEmpty {
                    Button(action: {}, label: {
                        Image(systemName: "mic.circle.fill")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.07, height: UIScreen.main.bounds.width * 0.07, alignment: .center)
                    })
                } else {
                    Button(action: {
                        
                        completion(textToSend)
                        textToSend = ""
                    }, label: {
                        Image(systemName: "paperplane.circle.fill")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.07, height: UIScreen.main.bounds.width * 0.07, alignment: .center)
                            .rotationEffect(.degrees(45))
                            
                    })
                }
           
        }.padding()
            .background(.gray.opacity(0.1))
    }
}

#Preview {
    TextFieldMessageView(completion:
                            {text in 
      print("Envia mensaje: \(text)")
    })
}

