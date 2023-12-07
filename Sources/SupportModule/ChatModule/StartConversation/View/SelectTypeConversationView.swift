//
//  StartConversationView.swift
//
//
//  Created by Danilo Hernandez on 31/10/23.
//

import SwiftUI

struct SelectTypeConversationView: View {
    public var queryTypesModel: [QueryTypesModel]
    @State var supportId: String = ""
    @StateObject var viewModel = StartConversationViewModel()
    @State var goToChat: Bool = false
    @State var isLoading: Bool = false
    
    var body: some View {
        
        VStack {
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                    VStack {
                        HStack {
                            Text("Selecciona una categoria")
                            Spacer()
                        }
                        showListQueries()
                       
                        NavigationLink(isActive: $goToChat) {
                            ChatView(toUUID:  supportId)
                        } label: {
                            EmptyView()
                        }
                    }.padding()
            }
        }
    }
    
    @ViewBuilder
    func showListQueries() -> some View {
        ScrollView(showsIndicators: true) {
            ForEach(queryTypesModel) { query in
                
                CardView(information: CardModel(id: query.id, titleFormat: query.title, action: ""), activeNavigation: $goToChat) {
                    isLoading.toggle()
                    viewModel.getAvailableSupports { result in
                        switch result {
                            case .success(let result):
                                supportId = result
                                isLoading.toggle()
                                goToChat.toggle()
                                
                            case .failure(let error):
                                print(error)
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5 , alignment: .center)
            }
        }
    }

}

#Preview {
    SelectTypeConversationView(queryTypesModel: MockInformation.queryTypesModelArray)
}
