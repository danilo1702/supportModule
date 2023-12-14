//
//  CardRecentMessageView.swift
//
//
//  Created by Danilo Hernandez on 28/11/23.
//

import SwiftUI

public struct CardRecentMessageView: View {
    
    public var information: CardModel
    
    public var body: some View {
        VStack(alignment: information.imageUrl != nil ? .leading : .center) {
            
            if information.nameFormat != nil {
                HStack {
                    TextView(informationModel: information.nameFormat!)
                        .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 0))
                    Spacer()
                }
                
            }
            
            HStack {
                TextView(informationModel: information.titleFormat)
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 10, trailing: 0))
                if information.toUUID != nil {
                    Spacer()
                }
                if information.indicator ?? false {
                    Circle()
                        .fill(.blue)
                        .frame(width: 15, height: 15, alignment: .center)
                        .padding()
                }
            }
            
            HStack {
                Spacer()
                TextView(informationModel: information.dateFormat ?? TextViewModel(text: CommonStrings.emptyString))
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    CardRecentMessageView(information: MockInformation.cardModel)
}
