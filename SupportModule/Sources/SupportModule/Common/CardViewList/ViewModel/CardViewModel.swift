//
//  CardViewModel.swift
//
//
//  Created by Danilo Hernandez on 30/10/23.
//

import Foundation

public class CardViewModel: ObservableObject {
    
}

extension CardViewModel {
    func getActionCard(action: String, view: CardView) -> () {
        
        switch action {
            case "link":
                return { view.$isPresented.wrappedValue = true}()
            case "chat":
                return { view.$activeNavigation.wrappedValue = true}()
            default:
                break
        }
    }
}
