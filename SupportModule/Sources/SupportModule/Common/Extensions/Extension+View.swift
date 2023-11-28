//
//  File.swift
//  
//
//  Created by Danilo Hernandez on 27/10/23.
//

import SwiftUI

extension View {
    
    func imageCardView() -> some View {
       modifier(ImageCardViewModifer()) 
    }
    func addSearchbar(textSearch: Binding<String>, placeHolder: String, title: TextViewModel?) -> some View {
        self.modifier(SearchBarModifier(textSearch: textSearch, placeHolder: placeHolder, title: title))
    }
    func showNavigationLink(link: String, show: Binding<Bool>) -> some View {
        self.modifier(ShowLinkNavigationModifier(link: link, show: show))
    }
    
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}
