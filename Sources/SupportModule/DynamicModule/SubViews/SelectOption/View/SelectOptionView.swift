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

//#Preview {
//    SelectOptionView(messageModel: SpecialMessage(metaData: MockInformation.metaDataCheckBox))
//}

struct SelectOptionViewV2: View {
    public var messageModel: MessageModel

    @Binding public var selection: String
    
    init(messageModel: MessageModel, selection: Binding<String>) {
        self.messageModel = messageModel
        self._selection = selection
    }
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(messageModel.message)
                .font(.system(size:  18.0, weight: .bold ,design: .rounded))
                
               
            ForEach(messageModel.options ?? [], id: \.id) { item in
                showItems(item)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .leading)
    }
    @ViewBuilder
    func showItems(_ item: OptionsMessageModel) -> some View {
        HStack {
            
            Button(action: {
                selection = item.text
            }, label: {
                Image(systemName: selection == item.text ? CommonStrings.ImagesString.circleFill : CommonStrings.ImagesString.circleEmpty)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.06, height: UIScreen.main.bounds.width * 0.06, alignment: .leading)
                    .aspectRatio(contentMode: .fit)
            })
            
            Text(item.text)
                
        }
    }
}

//#Preview {
//    SelectOptionViewV2(messageModel: MessageModel(id: "2", message: "Hola", fromUUID: "22", toUUID: "33", fromName: "Danilo", messageRead: false, type: "", options: [OptionsMessageModel(text: "Cedula"), OptionsMessageModel(text: "Tarjeta")]), selection: .constant(""))
//}
