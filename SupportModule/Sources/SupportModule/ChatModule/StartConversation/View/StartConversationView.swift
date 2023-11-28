//
//  StartConversationView.swift
//  
//
//  Created by Danilo Hernandez on 31/10/23.
//

import SwiftUI

struct StartConversationView: View {
    public var queryTypesModel: [QueryTypesModel]
    @State public var goToChat: Bool = false
    
    var body: some View {
       
            GeometryReader { geometry in
                
                VStack {
                    HStack {
                        Text("Selecciona una categoria")
                        Spacer()
                    }
                    showListQueries(geometry: geometry)
                }.padding()
            }
        
    }
    
    @ViewBuilder
    func showListQueries(geometry: GeometryProxy) -> some View {
        ScrollView(showsIndicators: true) {
            ForEach(queryTypesModel) { query in
                NavigationLink(
                    destination: Text("Start new Chat: \(query.title.text)"),
                    isActive: $goToChat,
                    label: {
                        CardView(information: CardModel(id: query.id, titleFormat: query.title, action: "chat"), activeNavigation: $goToChat) { }
                    })
            }
        }
        .frame(width: .infinity, height: geometry.size.height * 0.5 , alignment: .center)
    }
}

#Preview {
    StartConversationView(queryTypesModel: MockInformation.queryTypesModelArray)
}
