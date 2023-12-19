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
    @State var searching: Bool = false
    @State var oldValue: String = ""
    
    public init(textSearch: Binding<String>, placeHolder: String, title: TextViewModel? = nil, completion: @escaping () -> ()) {
        self._textSearch = textSearch
        self.placeHolder = placeHolder
        self.title = title
        self.completion = completion
    }
    
    
    public func body(content: Content) -> some View {
        NavigationView {
            
            ZStack{
                ShapeMainView()
                    .fill(.blue)
                    .ignoresSafeArea()
                    .shadow(radius: 20)
                ScrollView {
                   
                        
                        VStack {
                            if let text = title {
                                HStack {
                                    TextView(informationModel: text)
                                        .shadow(radius: 6)
                                    Spacer()
                                }.padding()
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
                                        .background(.white))
                                .cornerRadius(CGFloat( 15.0))
                                .padding(.init(top: 20, leading: 20, bottom: 20, trailing: textSearch.isEmpty ? 20 : 10))
                                .onTapGesture {
                                    hidePlaceHolder = true
                                }
                                if !textSearch.isEmpty {
                                    Button(action: {
                                        withAnimation(.smooth) {
                                            actionButton()
                                        }
                                        
                                    }, label: {
                                        Text( searching ? "Cancelar" : "Buscar")
                                            .padding(.init(top: 20, leading: 0, bottom: 20, trailing: 10))
                                    })
                                }
                            }
                            .onChange(of: textSearch, perform: { value in
                                if value.isEmpty || oldValue != value{
                                    searching = false
                                }
                            })
                            
                            Spacer()
                            content
                        }
                }
            }
        }.ignoresSafeArea()
    }
    func actionButton() -> () {
        oldValue = textSearch
        
        if searching  {
            textSearch = ""
            searching.toggle()
            completion()
        } else  {
            searching.toggle()
            completion()
        }
    }
}

