//
//  CalifiationView.swift
//
//
//  Created by Danilo Hernandez on 14/12/23.
//

import SwiftUI

struct CalifiationView: View {
    @State var stairs: [RangeStairsModel] = [RangeStairsModel(position: 1, status: false), RangeStairsModel(position: 2, status: false),RangeStairsModel(position: 3, status: false),RangeStairsModel(position: 4, status: false),RangeStairsModel(position: 5, status: false)]
    var mock: [CardModel] = [CardModel(id: "1", titleFormat: TextViewModel(text: "Profesional")),CardModel(id: "2", titleFormat: TextViewModel(text: "Regular")),CardModel(id: "3", titleFormat: TextViewModel(text: "Profesional")),CardModel(id: "4", titleFormat: TextViewModel(text: "Muy amable")),CardModel(id: "5", titleFormat: TextViewModel(text: "Malo"))]
    var body: some View {
        VStack {
            
            Text("Califica tu experiencia")
            Text("¿Se resolvió tu inquietud?")
            
            showStairs()
                .padding()
            
            ForEach(mock, id: \.id) { mock in
                CardView(information: mock) {
                }
            }
            
            Button {
                if let calification =  stairs.last(where: {$0.status == true}) {
                    print(calification)
                }
            } label: {
                Text("Enviar")
            }

        }
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    func showStairs() -> some View {
        
        HStack {
            ForEach(stairs, id: \.id) { position in
                stairDesign(selected: position.status)
                    .onTapGesture {
                        stairs = stairs.map{ $0.position <= position.position ? RangeStairsModel(position: $0.position, status: true) : RangeStairsModel(position: $0.position, status: false) }
                    }
            }
        }
    }
    
    @ViewBuilder
    func stairDesign(selected: Bool) -> some View {
        
        Image(systemName: selected ? "star.fill" : "star").foregroundStyle(.yellow)
    }
}

#Preview {
    CalifiationView()
}
