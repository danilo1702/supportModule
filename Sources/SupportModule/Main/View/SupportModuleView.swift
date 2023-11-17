//
//  SwiftUIView.swift
//
//
//  Created by Danilo Hernandez on 27/10/23.
//

import SwiftUI
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
public class FirestoreManager {
    public static let shared = FirestoreManager()


    private lazy var firestore: Firestore = {
        FirebaseApp.configure()
        return Firestore.firestore()
    }()

    public func getFirestoreInstance() -> Firestore {
        return firestore
    }
}
public struct SupportModuleView: View {
    

    @State public var isPresented: Bool  = false
    @State public var textSearch: String = ""
    @State public var lastChat: Bool = true
    @State public var navigationChat: Bool = false
    @State public var lastChatInformation: CardModel =  MockInformation.cardModelChatHistory
    @State public var showAlert: Bool = false
    @State public var newConversacion: Bool = false
    public var arrayDemo =  MockInformation.cardListArray
    public var generalConfiguration: GeneralConfiguration = MockInformation.generalConfiguration
    @StateObject public var viewModel: SupportMainViewModel
    
    public init(firestore: Firestore) {
        
        self._viewModel = StateObject(wrappedValue: SupportMainViewModel(dbFirestore: firestore))
    }
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                showListArticles()
                    .padding(.horizontal)
                    .frame(width: .infinity, height: geometry.size.height * 0.4, alignment: .center)
                
                if lastChat {
                    VStack {
                        HStack{
                            TextView(informationModel: generalConfiguration.titleLastChat)
                                .shadow(radius: 7)
                            Spacer()
                        }.padding(19)
                        
                        CardView(information: lastChatInformation, activeNavigation: $navigationChat) {}
                            .padding(.horizontal)
                       //Text("Historial de chats")
                    }
                }
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
            .addSearchbar(textSearch: $textSearch, placeHolder: generalConfiguration.placeHolderSearchBar, title: generalConfiguration.titleModule)
            .onAppear{
                viewModel.getArticles { result in
                    switch result {
                        case .success(let success):
                            viewModel.convertToCardModel(articlesHelp: success)
                        case .failure(let error):
                            print("error getting Articles \(error)")
                            
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func showListArticles() -> some View {

        ScrollView(showsIndicators: false) {
            ForEach(viewModel.articles, id: \.uniqueId) { article in
                CardView(information: article) { }
            }
        }
    }
    
    @ViewBuilder
    func navigationLinks() -> some View{
        VStack {
            
         NavigationLink(
            destination: ChatView(),
            isActive: $navigationChat,
            label: {
                EmptyView()
            })
        NavigationLink(
            destination: StartConversationView(queryTypesModel: MockInformation.queryTypesModelArray),
            isActive: $newConversacion,
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
        }.addSearchbar(textSearch: $textSearch, placeHolder: "Buscar por zona", title: nil)
    }
}
