//
//  SupportModuleView.swift
//
//
//  Created by Danilo Hernandez on 27/10/23.
//

import SwiftUI
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

public struct SupportModuleView: View {
    
    
    @State public var isPresented: Bool  = false
    @State public var textSearch: String = ""
    @State public var lastChat: Bool = true
    @State public var navigationChat: Bool = false
    @State public var lastChatInformation: CardModel =  MockInformation.cardModelChatHistory
    @State public var showAlert: Bool = false
    @State public var newConversacion: Bool = false
    @State public var chatHistory: Bool = false
    @State public var loadingArticles: Bool = true
    @State public var loginSuccess: CardModel = CardModel(id: "", titleFormat: TextViewModel(text: ""))
    @StateObject public var viewModel: SupportMainViewModel = SupportMainViewModel()
    
    public var arrayDemo =  MockInformation.cardListArray
    public var generalConfiguration: GeneralConfiguration = MockInformation.generalConfiguration
    
    public init() {}
    
    public var body: some View {
        
        NavigationView{
            VStack {
                showListArticles()
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4, alignment: .center)
                
                //if viewModel.recentMessage.count > 0 {
                    VStack {
                        HStack{
                            TextView(informationModel: generalConfiguration.titleLastChat)
                                .shadow(radius: 7)
                            Spacer()
                            Button(action: {chatHistory.toggle()}, label: {
                                Text("Historial")
                            })
                            
                        }.padding(19)
                        
//                        CardView(information: loginSuccess, activeNavigation: $navigationChat, view: CardRecentMessageView(information: loginSuccess).toAnyView()) {
//                            
//                        }
//                        CardView(information: viewModel.recentMessage[0], activeNavigation: $navigationChat, view: CardRecentMessageView(information: viewModel.recentMessage[0]).toAnyView()) {}
//                            .padding(.horizontal)
                        
                    }
                //}
                Spacer()
                ButtonView(informationButton:ButtonModel(designButton: ComponentDesign(backgroundColor: .blue, cornerRaiuds: 15), title: TextViewModel(text: "Agendar turno", foregroundColor: .white, font: .system(size: 14), expandable: false)) ) {
                    showAlert.toggle()
                }
                .sheet(isPresented: $showAlert, content: {
                    ProgramTurnView()
                })
                
                
                ButtonView(informationButton: generalConfiguration.buttonInformationStartChat) {
                    newConversacion.toggle()
                }
                .padding()
                .frame(alignment: .center)
                
                .shadow(radius: 5)
                navigationLinks()
            }
            .addSearchbar(textSearch: $textSearch, placeHolder: generalConfiguration.placeHolderSearchBar, title: generalConfiguration.titleModule, completion: {
                gettingArticles()
            })
            .onAppear{
                viewModel.registerUserFirebase{ result in
                    switch result {
                        case .success(let success):
                            if success {
                                viewModel.loginFirebase { result in
                                    switch result {
                                        case .success((let status, let user)):
                                            if status {
                                                DispatchQueue.main.async {
                                                    gettingArticles()
                                                }
                                            }
                                        case .failure(let error):
                                            print(error)
                                    }
                                }
                            }
                        case .failure(let failure):
                            print(failure)
                    }
                }
                DispatchQueue.main.async {
                    viewModel.getLastChats()
                }
                
            }
        }
    }
    func gettingArticles()  {
        
        textSearch.isEmpty ?
        viewModel.getArticlesV2 { result in
            loadingArticles.toggle()
            switch result {
                case .success(let success):
                    
                    viewModel.convertToCardModel(articlesHelp: success)
                case .failure(let error):
                    print("error getting Articles \(error)")
            }
        } : viewModel.searchArticle(text: textSearch) { result in
            loadingArticles.toggle()
            switch result {
                case .success(let articles) :
                    viewModel.convertToCardModel(articlesHelp: articles)
                case .failure(let error):
                    print("error \(error)")
            }
        }
    }
    
    @ViewBuilder
    func showListArticles() -> some View {
        
        if viewModel.articles.count > 0 {
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.articles, id: \.uniqueId) { article in
                    CardView(information: article) { }
                }
            }
        } else {
            if loadingArticles {
                ProgressView()
            } else  {
                Text("No se encontraron resultados")
            }
        }
    }
    
    @ViewBuilder
    func navigationLinks() -> some View{
        let toUUID = (viewModel.recentMessage.count > 0 ? viewModel.recentMessage[0].toUUID ?? "" ==  Auth.auth().currentUser?.uid ? viewModel.recentMessage[0].fromUUID ?? "" : viewModel.recentMessage[0].toUUID ?? "" : "")
        
        VStack {
            NavigationLink(
                destination: ChatView(toUUID: toUUID),
                isActive: $navigationChat,
                label: {
                    EmptyView()
                })
            NavigationLink(
                destination: SelectTypeConversationView(queryTypesModel: MockInformation.queryTypesModelArray),
                isActive: $newConversacion,
                label: {
                    EmptyView()
                })
            NavigationLink(
                destination: ChatHistoryView(),
                isActive: $chatHistory,
                label: {
                    EmptyView()
                })
        }
    }
}

//#Preview {
//
//    SupportModuleView()
//}

struct ProgramTurnView: View {
    public var arrayDemo =  MockInformation.cardListZonas
    @State var showAlert: Bool = false
    @State public var textSearch: String = ""
    var body: some View {
        VStack {
            showListArticles()
        }
    }
    @ViewBuilder
    func showListArticles() -> some View {
        
        ScrollView(showsIndicators: false) {
            ForEach(arrayDemo, id: \.uniqueId) { article in
                CardView(information: article) {
                    showAlert.toggle()
                } .alert(CommonStrings.programTurn, isPresented: $showAlert) {}
                
            } .padding()
        }.addSearchbar(textSearch: $textSearch, placeHolder: "Buscar por zona", title: nil, completion: {})
    }
}
