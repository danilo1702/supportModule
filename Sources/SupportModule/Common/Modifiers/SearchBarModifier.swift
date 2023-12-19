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
    public var completion: () -> ()
    @State var searching: Bool = false
    @State var oldValue: String = ""
    @Binding var remoteConfig: RemoteConfigModelMainView
    
    public init(remoteConfig: Binding<RemoteConfigModelMainView> ,textSearch: Binding<String>, completion: @escaping () -> ()) {
        self._remoteConfig = remoteConfig
        self._textSearch = textSearch
        self.completion = completion
    }
    
    public func body(content: Content) -> some View {
        NavigationView {
            
            ZStack{
                ShapeMainView()
                    .fill(Color(hex: remoteConfig.colorbackgroundImage))
                    .ignoresSafeArea()
                    .shadow(radius: 20)
                ScrollView {
                      
                        VStack {
                                HStack {
                                    TextView(informationModel: TextViewModel(text: remoteConfig.mainTitle.text, foregroundColor: Color(hex: remoteConfig.mainTitle.foregroundColor), font: .system(size: remoteConfig.mainTitle.fontSize.parseToCGFloat()).bold()))
                                        .shadow(radius: 6)
                                    Spacer()
                                }.padding()
                           
                            HStack {
                                
                                ZStack {
                                    HStack {
                                        Image(systemName: CommonStrings.ImagesString.magnifyingGlass)
                                            .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: -2))
                                            .foregroundStyle(.gray)
                                        if !hidePlaceHolder || textSearch.isEmpty{
                                            TextView(informationModel: TextViewModel(text: remoteConfig.searchBar.placeHolder.text, foregroundColor: Color(hex: remoteConfig.searchBar.placeHolder.foregroundColor), font: .system(size: remoteConfig.searchBar.placeHolder.fontSize.parseToCGFloat())))
                                                .foregroundStyle(.gray)
                                        }
                                        
                                        Spacer()
                                    }
                                    
                                    TextField(CommonStrings.emptyString, text: $textSearch).padding(EdgeInsets(top: 8, leading: 33, bottom: 8, trailing: 5))
                                    
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .strokeBorder(Color(hex: remoteConfig.searchBar.backgroundColor), lineWidth: 0.2)
                                        .background(Color(hex: remoteConfig.searchBar.backgroundColor)))
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
                                            .foregroundColor(Color(hex: remoteConfig.searchBar.backgroundColor))
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

