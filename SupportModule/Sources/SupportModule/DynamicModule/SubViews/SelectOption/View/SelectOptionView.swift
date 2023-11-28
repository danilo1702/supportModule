//
//  SelectOptionView.swift
//
//
//  Created by Danilo Hernandez on 10/11/23.
//

import SwiftUI

struct SelectOptionView: View {
    public var messageModel: SpecialMessage

    @State public var selection: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(messageModel.metaData.label ?? CommonStrings.emptyString)
                .font(.system(size: messageModel.metaData.fontSize ?? 15.0, weight: messageModel.metaData.bold ?? false ? .bold : .medium, design: .default))
                .foregroundStyle(Color(hex: messageModel.metaData.additionalInfo?.textColor ?? CommonStrings.ColorString.black))
               
            ForEach(messageModel.metaData.options ?? [], id: \.uiniqueId) { item in
                showItems(item)
            }
        }
        .padding()
        .frame(width: .infinity, height: .infinity, alignment: .leading)
    }
    @ViewBuilder
    func showItems(_ item: OptionItemModelV2) -> some View {
        HStack {
            
            Button(action: {
                selection = item.value
            }, label: {
                Image(systemName: selection == item.value ? CommonStrings.ImagesString.circleFill : CommonStrings.ImagesString.circleEmpty)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.06, height: UIScreen.main.bounds.width * 0.06, alignment: .leading)
                    .aspectRatio(contentMode: .fit)
            })
            
            Text(item.label)
                .foregroundStyle(Color(hex: item.foregroundColor))
        }
    }
}

#Preview {
    SelectOptionView(messageModel: SpecialMessage(metaData: MockInformation.metaDataCheckBox))
}
