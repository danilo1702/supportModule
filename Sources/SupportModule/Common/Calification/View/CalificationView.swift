//
//  CalifiationView.swift
//
//
//  Created by Danilo Hernandez on 14/12/23.
//

import SwiftUI


struct CalificationView: View {
    @State var stairs: [RangeStairsModel] = [RangeStairsModel(position: 1, status: false), RangeStairsModel(position: 2, status: false),RangeStairsModel(position: 3, status: false),RangeStairsModel(position: 4, status: false),RangeStairsModel(position: 5, status: false)]
    @Environment(\.dismiss) var dismiss
    @StateObject var calificationViewModel = CalificationViewModel()
    @State var optionSelected: OptionSelected = OptionSelected(id: "", name: "")
    @State var comment: String = ""
    @State var isSelected: Bool = false
    @State var companyLogo: String = ""
    @State var designView: CalificationDesignModel?
    
    
    var toUUID: String
    var rows: [GridItem] = [ GridItem(.fixed(150), spacing: 20, alignment: .center)
                             ,GridItem(.fixed(150), spacing: 1, alignment: .center)]
    var body: some View {
        VStack {
            
            Spacer()
            TextView(informationModel: TextViewModel(text: designView?.mainTitle.text ?? "", foregroundColor: Color(hex: designView?.mainTitle.foregroundColor ?? "#000000"), font: .system(size: designView?.mainTitle.fontSize.parseToCGFloat() ?? 14).bold()))
               
            Spacer()
            
            AsyncImage(url: URL(string: companyLogo)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3, alignment: .center)
                } else if phase.error != nil{
    
                } else {
                    ProgressView()
                }
            }
            .shadow(radius: 20)
            Spacer()
            TextView(informationModel: TextViewModel(text: designView?.secondTitle.text ?? "", foregroundColor: Color(hex: designView?.secondTitle.foregroundColor ?? "#000000"), font: .system(size: designView?.secondTitle.fontSize.parseToCGFloat() ?? 14).bold()))
            
            showStairs()
                .padding()
            
            LazyVGrid(columns: rows) {
                ForEach(calificationViewModel.optionsCalification, id: \.id) { option in
                    CardView(information: option.model, isSelected: .constant(option.selected)) {
                        activeCard(option: option)
                    }
                }
            }
            Spacer()
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
                TextView(informationModel: TextViewModel(text: designView?.completeButton.text.text ?? "", foregroundColor: Color(hex: designView?.completeButton.text.foregroundColor ?? "#000000"), font: .system(size: designView?.completeButton.text.fontSize.parseToCGFloat() ?? 14)))
            }
            .padding()
            .background(Color(hex: designView?.completeButton.backgroundColor ?? "#E6E6E6"))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            Spacer()
        }
        .onAppear{
            DispatchQueue.main.async {
                calificationViewModel.getRemoteDesign { result in
                    switch result {
                        case .success(let success):
                            companyLogo = success.companyLogo
                            designView = success
                        case .failure(_):
                            break
                    }
                }
                calificationViewModel.getOptions()
            }
        }
    }
    func activeCard(option: OptionsCalification) {
        
        guard let _ = calificationViewModel.optionsCalification.firstIndex(where: {$0.model.id == option.model.id}) else {
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
        
        Image(systemName: selected ? designView?.star.sfImageFill ?? "star.fill" : designView?.star.sfImage ?? "star")
            .foregroundStyle(Color(hex: designView?.star.foregroundColor ?? "#0040FF"))
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
