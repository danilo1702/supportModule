//
//  SwiftUIView.swift
//  
//
//  Created by Danilo Hernandez on 31/10/23.
//

import SwiftUI

public struct ButtonView: View {
    
    public var informationButton: ButtonModel
    public var completion: () -> ()
    
    public var body: some View {
        
        Button {
            completion()
        } label: {
                Label(
                    title: {  TextView(informationModel: informationButton.title)},
                    icon: { if let image = informationButton.image {
                        image
                            .resizable()
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fill)
                            .frame(width: 20, height: 10, alignment: .center)
                    }}
                )
        }
        .padding()
        .background(informationButton.designButton.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: informationButton.designButton.cornerRaiuds))
    }
}

#Preview {
    ButtonView(informationButton: MockInformation.buttonModel, completion: { print("Hola")})
}
