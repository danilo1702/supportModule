//
//  ShowLinkNavigationModifier.swift
//  
//
//  Created by Danilo Hernandez on 30/10/23.
//


import SwiftUI

public struct ShowLinkNavigationModifier: ViewModifier {
    
    public var link: String
    @Binding public var show: Bool
    public var turn: Bool = false
    
    public func body(content: Content) -> some View {
        
            content
            .sheet(isPresented: $show, content: {
            VStack{
                HStack{
                    if turn {
                        Button(action: { show.toggle()
                            print(link)}, label: {
                                
                            HStack{
                                Text(CommonStrings.turn).foregroundStyle(.white)
                                Image(systemName: "calendar.badge.checkmark").foregroundStyle(.white)
                            }
                            .padding(3)
                            .background(
                                RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
                                .background(.green))
                            .cornerRadius(15)
                        })
                    }
                    Spacer()
                    Button(action: { show.toggle()
                        print(link)}, label: {
                            
                        HStack{
                            Text(CommonStrings.close).foregroundStyle(.white)
                            Image(systemName: CommonStrings.ImagesString.closeIcon).foregroundStyle(.white)
                        }
                        .padding(3)
                        .background(
                            RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
                            .background(.blue))
                        .cornerRadius(15)
                    })
                    
                }
                .padding()
                WebViewContainer(url: link)
            }
        })
    }
}
