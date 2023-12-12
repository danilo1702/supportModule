//
//  SupportMainViewModel.swift
//
//
//  Created by Danilo Hernandez on 30/10/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore



public class SupportMainViewModel: ObservableObject {
    
    @Published public var articles: [CardModel] = []
    @Published public var recentMessage: [CardModel] = []
    var deviceInformation = InformationDevice()
    var arrayArticles: [InformationCardApi] = []
    @Published public var supportInformation = MessageModel(message: "", fromUUID: "", toUUID: "", fromName: "")
    func registerUserFirebase(completion: @escaping(Result<Bool, Error>)-> ()) {
        deviceInformation.returnInformation()
        
        FirebaseManagerData.initialization.dbAuth.createUser(withEmail: deviceInformation.email, password: deviceInformation.deviceUUID) {  authResult, error in
            
            guard let user = authResult?.user, error == nil else {
                if let nsError = error as? NSError, let error = AuthErrorCode.Code(rawValue: nsError.code)  {
                    switch error {
                        case .emailAlreadyInUse:
                            completion(.success(true))
                        default:
                            completion(.failure(nsError))
                    }
                }
                return
            }
            self.registerInfoUser(uuid: user.uid)
            completion(.success(true))
        }
    }
    func registerInfoUser(uuid: String) {
        let information = PersonalInformationUser(email: deviceInformation.email, uuid: uuid, name: UIDevice.modelName)
        
        do {
            try FirebaseManagerData.initialization.dbFirestore.collection(FirebaseConstants.users).document(uuid).setData(from: information)
        } catch let error {
            print("Error writing the user to Firestore: \(error)")
        }
    }
    
    
    func getLastChats() {
        
        guard let userUUID = FirebaseManagerData.initialization.dbAuth.currentUser?.uid else { return }
        
        
        let reference = FirebaseManagerData.initialization.dbFirestore.collection(FirebaseConstants.lastMessages)
            .document(userUUID)
            .collection(FirebaseConstants.messages)
        
        reference.addSnapshotListener { [weak self] querySnapshot, error in
            
            guard let self = self, let querySnapshot = querySnapshot, error == nil else { return }
            
            querySnapshot.documentChanges.forEach { change in
                
                let documentId = change.document.documentID
//                if let index = self.recentMessage.firstIndex(where: { $0.id == documentId}) {
//                    self.recentMessage.remove(at: index)
//                }
                if let message = try? change.document.data(as: MessageModel.self) {
                    
                    DispatchQueue.main.async {
                        self.supportInformation = MessageModel(message: message.message, fromUUID: message.fromUUID, toUUID: message.toUUID,timestamp: message.timestamp, fromName: message.fromName)
                        
                        self.recentMessage.insert(CardModel(id: message.id ?? "1", titleFormat: TextViewModel(text: message.message, foregroundColor: .black, font: .system(size: 14), expandable: false), dateFormat: TextViewModel(text: "\(String(describing: message.timestamp!.dateValue().formatted(date: .numeric, time: .shortened)))", foregroundColor: .gray, font: .system(size: 11), expandable: false), nameFormat:  TextViewModel(text: userUUID == message.fromUUID ? "Tú:" : message.fromName, foregroundColor: .black, font: .system(size: 13, weight: .bold), expandable: false) , designCard: ComponentDesign(backgroundColor: .gray.opacity(0.1), cornerRaiuds: 15),fromUUID: message.fromUUID ,toUUID: message.toUUID, action: "chat"), at: 0)
                    }
                    
                }
            }
        }
    }
    func loginFirebase(completion: @escaping (Result<(Bool,AuthDataResult), Error>) -> ()) {
        
        Auth.auth().signIn(withEmail: deviceInformation.email, password: deviceInformation.deviceUUID) {  authResult, error in
            guard let user = authResult, error == nil else {
                completion(.failure(error ?? NSError(domain: "Error with sign In firebase", code: 504)))
                return }
            completion(.success((true, user)))
        }
    }
    func getSearchArticle (text: String) {
        
        let reference = FirebaseManagerData.initialization.dbFirestore.collection(CommonStrings.ArticlesStringApi.articles)
            .document(CommonStrings.ArticlesStringApi.help)
        
        reference.addSnapshotListener { documentSnapshot, error in
            
        }
    }
    func searchArticle(text: String, completion: @escaping (Result<[InformationCardApi], Error>) -> ()) {
        self.arrayArticles = []
        let arrayText = text.components(separatedBy: " ")
        let reference = FirebaseManagerData.initialization.dbFirestore.collection(CommonStrings.ArticlesStringApi.articles)
        
        reference.whereField(CommonStrings.ArticlesStringApi.keyWords, arrayContainsAny: arrayText).getDocuments { [weak self] query, error in
            guard let self = self, let query = query , error == nil else {
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey : CommonStrings.Errors.errorGettingData])))
                return
            }
            
            query.documents.forEach { query in
                do {
                    let article = try query.data(as: InformationCardApi.self)
                    self.arrayArticles.append(article)
                    
                } catch {
                    #if DEBUG
                    print("Error getting articles searched \(String(describing: error))")
                    #endif
                }
            }
            completion(.success(self.arrayArticles))
        }
    }
    
    func getArticlesV2(completion: @escaping (Result<[InformationCardApi], Error>) -> ()) {
        let reference = FirebaseManagerData.initialization.dbFirestore.collection(CommonStrings.ArticlesStringApi.articles)
        
        self.arrayArticles = []
        articles = []
        reference.addSnapshotListener { querySnapshot, error in
            guard let querySnapshot = querySnapshot , error == nil else {
                completion(.failure(error ?? NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey : CommonStrings.Errors.errorGettingData])))
#if DEBUG
                print("Error getting articles \(String(describing: error))")
#endif
                return
            }
            
            querySnapshot.documentChanges.forEach { documentChange in
                do {
                    
                    let article = try documentChange.document.data(as: InformationCardApi.self)
                    let position =  self.arrayArticles.firstIndex(where: {$0.id == article.id})
        
                    switch documentChange.type {
                        case .modified:
                            guard let position = position else { return }
                                self.arrayArticles[position] = article
                        case .added:
                            self.arrayArticles.append(article)
                        case .removed:
                            guard let position = position else { return }
                            self.arrayArticles.remove(at: position )
                    }
                }catch {
                    
                    completion(.failure(error))
#if DEBUG
                    print(error)
#endif
                }
            }
            completion(.success(self.arrayArticles))
        }
    }
    
    func getArticles(completion: @escaping(Result<[InformationCardApi], Error>) -> Void) {
        let reference = FirebaseManagerData.initialization.dbFirestore.collection(CommonStrings.ArticlesStringApi.articles).document(CommonStrings.ArticlesStringApi.help)
        articles = []
        reference.addSnapshotListener { snapshot, error in
            if let error = error {
                print("\(CommonStrings.Errors.errorGettingDocument) \(error)")
                completion(.failure(error))
            } else {
                if let articles = snapshot, articles.exists {
                    let decoder = Firestore.Decoder()
                    do {
                        if let data = articles.data()?[CommonStrings.ArticlesStringApi.information] as? [[String: Any]] {
                            let arrayArticle = try data.map{ try decoder.decode(InformationCardApi.self, from: $0)}
                            completion(.success(arrayArticle))
                        } else {
                            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey : CommonStrings.Errors.errorGettingData])))
                        }
                    } catch {
                        print(CommonStrings.Errors.errorDecoding)
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey : CommonStrings.Errors.routNoExist])))
                }
            }
        }
    }
    
    func convertToCardModel(articlesHelp: [InformationCardApi]) {
        articles = []
        articlesHelp.forEach { information in
            self.articles.append(CardModel(id: information.id ?? "", image: ImageModel(image: information.image?.image ?? "", backgroundColor: Color(hex: information.image?.backgroundColor ?? "")), link: information.link, titleFormat: TextViewModel(text: information.titleFormat.text, foregroundColor: Color(hex: information.titleFormat.foregroundColor), font: Font.system(size: information.titleFormat.fontSize.parseToCGFloat()), expandable: information.titleFormat.expandable ?? false), dateFormat: TextViewModel(text: information.dateFormat?.text ?? "", foregroundColor: Color(hex: information.dateFormat?.foregroundColor ?? "#000000"), font: Font.system(size: information.dateFormat?.fontSize.parseToCGFloat() ?? 0), expandable: information.dateFormat?.expandable ?? false) , designCard: ComponentDesign(backgroundColor: Color(hex: information.designCard?.backgroundColor ?? "#DAF1F0"), cornerRaiuds: information.designCard?.cornerRaiuds?.parseToCGFloat() ?? 15), action: information.action ?? ""))
        }
    }
}
