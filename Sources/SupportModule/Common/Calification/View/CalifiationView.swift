//
//  CalifiationView.swift
//
//
//  Created by Danilo Hernandez on 14/12/23.
//

import SwiftUI

struct CalifiationView: View {
    @State var stairs: [RangeStairsModel] = [RangeStairsModel(position: 1, status: false), RangeStairsModel(position: 2, status: false),RangeStairsModel(position: 3, status: false),RangeStairsModel(position: 4, status: false),RangeStairsModel(position: 5, status: false)]
    @Environment(\.dismiss) var dismiss
    @StateObject var calificationViewModel = CalificationViewModel()
    @State var optionSelected: OptionSelected = OptionSelected(id: "", name: "")
    @State var comment: String = ""
    @State var isSelected: Bool = false
    
    var toUUID: String
    var rows: [GridItem] = [ GridItem(.fixed(150), spacing: 5, alignment: .center)
                             ,GridItem(.fixed(150), spacing: 1, alignment: .center)]
    var body: some View {
        VStack {
            
            Text("Califica tu experiencia")
            Text("¿Se resolvió tu inquietud?")
            
            showStairs()
                .padding()
            
            LazyVGrid(columns: rows) {
                ForEach(calificationViewModel.optionsCalification, id: \.id) { option in
                    CardView(information: option.model, isSelected: .constant(option.selected)) {
                        activeCard(option: option)
                    }
                }
            }
            Button {
                if allOk() {
                    calificationViewModel.sendInformation(information: getInformationTosend(), toUUID: toUUID) { result in
                        switch result {
                            case .success( _ ):
                                    dismiss()
                        }
                    }
                }
            } label: {
                Text("Enviar")
            }
        }
        .onAppear{
            DispatchQueue.main.async {
                calificationViewModel.getOptions()
            }
        }
    }
    func activeCard(option: OptionsCalification) {
        
        guard let index = calificationViewModel.optionsCalification.firstIndex(where: {$0.model.id == option.model.id}) else {
            return }
        calificationViewModel.optionsCalification = calificationViewModel.optionsCalification.map({ OptionsCalification(selected: option.model.id == $0.model.id ? true : false, model: $0.model)
        })

        optionSelected = OptionSelected(id: option.model.id , name: option.model.titleFormat.text)
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
    func allOk() -> Bool {
        guard  let _ =  stairs.last(where: {$0.status == true}), optionSelected.name != "" else { return false }
        return true
    }
    func getInformationTosend() -> SendCalification {
        let stair = stairs.last(where: {$0.status == true})
        return SendCalification(stairs: stair!.position,finished: true, qualified: true ,valoration: optionSelected, comment: comment)
    }
}
