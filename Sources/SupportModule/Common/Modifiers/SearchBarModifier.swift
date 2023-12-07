//
//  SearchBarModifier.swift
//
//
//  Created by Danilo Hernandez on 30/10/23.
//

import SwiftUI

public struct SearchBarModifier: ViewModifier {
    
    @Binding public var textSearch: String
    @State public var hidePlaceHolder: Bool = false
    public var placeHolder: String
    public var title: TextViewModel?
    public var completion: () -> ()
    
    public init(textSearch: Binding<String>, placeHolder: String, title: TextViewModel? = nil, completion: @escaping () -> ()) {
        self._textSearch = textSearch
        self.placeHolder = placeHolder
        self.title = title
        self.completion = completion
    }
    
    
    public func body(content: Content) -> some View {
        NavigationView {
            ScrollView {
                VStack {
                    if let text = title {
                        TextView(informationModel: text)
                            .shadow(radius: 6)
                    }
                    HStack {
                        
                        ZStack {
                            HStack {
                                Image(systemName: CommonStrings.ImagesString.magnifyingGlass)
                                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: -2))
                                    .foregroundStyle(.gray)
                                if !hidePlaceHolder || textSearch.isEmpty{
                                    Text(placeHolder)
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                            }
                            
                            TextField(CommonStrings.emptyString, text: $textSearch).padding(EdgeInsets(top: 8, leading: 33, bottom: 8, trailing: 5))
                            
                            
                            
                            
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(.gray, lineWidth: 0.2)
                                .background(.gray.opacity(0.2)))
                        .cornerRadius(CGFloat( 15.0))
                        .padding()
                        .onTapGesture {
                            hidePlaceHolder = true
                        }
                        if !textSearch.isEmpty {
                            Button(action: { completion() }, label: {
                                Text("Buscar")
                            })
                        }
                    }
                    Spacer()
                    content
                }
            }}
    }
}

