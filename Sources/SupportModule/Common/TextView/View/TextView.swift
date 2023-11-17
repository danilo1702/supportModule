//
//  TextView.swift
//
//
//  Created by Danilo Hernandez on 27/10/23.
//

import SwiftUI

public struct TextView: View {
    public var informationModel : TextViewModel
    @State public var expandable: Bool
    
    public init( informationModel: TextViewModel) {
        self.informationModel = informationModel
        self._expandable = State(initialValue: informationModel.expandable)
    }
    
    public var body: some View {
        
        VStack {
            Text(returnText())
                .multilineTextAlignment(.leading)
                .font(informationModel.font)
                .foregroundStyle(informationModel.foregroundColor)
            if informationModel.expandable {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            expandable.toggle()
                        }
                    }, label: {
                        Text(expandable ? CommonStrings.TextViewStrings.seeMore : CommonStrings.TextViewStrings.seeLess)
                            .font(.system(size: 13))
                    }).padding(2)
                }
            }
        }
    }
    func returnText() -> String {
        return  (informationModel.text.prefix(expandable ? 50 : 1000)) + (informationModel.text.count > 50 && expandable ? CommonStrings.TextViewStrings.ellipsis : CommonStrings.emptyString)
    }
}

#Preview {
    TextView(informationModel: MockInformation.textViewModel)
}
