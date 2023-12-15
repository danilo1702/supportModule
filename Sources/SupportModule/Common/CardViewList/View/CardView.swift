//
//  CardView.swift
//
//
//  Created by Danilo Hernandez on 27/10/23.
//

import SwiftUI
import WebKit
import Combine


public struct CardView: View {
    
    public var information: CardModel
    public var completion: () -> ()
    public var view: AnyView?
    @StateObject public var viewModel: CardViewModel = CardViewModel()
    @State public var isPresented: Bool = false
    @Binding public var activeNavigation: Bool
    @Binding public var isSelected: Bool
    public init(information: CardModel, activeNavigation: Binding<Bool> = .constant(false), isSelected: Binding<Bool> = .constant(false), view: AnyView? = nil, completion: @escaping () -> ()) {
        self.information = information
        self._activeNavigation = activeNavigation
        self._isSelected = isSelected
        self.view = view
        self.completion = completion
    }
    
    public var body: some View {
        
        VStack {
            HStack {
                if let url = information.imageUrl {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .imageCardView()
                        } else if phase.error != nil {
                            Image(systemName: CommonStrings.ImagesString.person)
                                .resizable()
                                .imageCardView()
                        } else {
                            ProgressView()
                                .imageCardView()
                        }
                    }
                    .padding()
                    .background(information.image?.backgroundColor)
                }
                
                if let view = view {
                    view
                } else {
                    VStack(alignment: information.imageUrl != nil ? .leading : .center) {

                            TextView(informationModel: information.titleFormat)
                                .padding()
                            HStack {
                                Spacer()
                                TextView(informationModel: information.dateFormat ?? TextViewModel(text: CommonStrings.emptyString))
                                    .padding(.horizontal)
                            }
                    }
                }
                
                
            }
        }

        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        //.frame(idealWidth: .infinity, idealHeight:  information.imageUrl != nil ? 105 : 100, alignment: .center)
        .background(isSelected ? information.designCard.colorSelected : information.designCard.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: information.designCard.cornerRaiuds))
        .shadow(radius: 0)
        .onTapGesture {
            isSelected = true
            viewModel.getActionCard(action: information.action, view: self)
            completion()
        }
        .showNavigationLink(link: information.link ?? "", show: $isPresented)
    }
}


#Preview {
    CardView(information: MockInformation.cardModelChatHistory, activeNavigation: .constant(false), completion: { })
    .frame(width: .infinity, height: 150, alignment: .center)
}

