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



public class SupportMainViewModel: ObservableObject {
    @Published public var dbFirestore: Firestore = Firestore.firestore()
    @Published public var articles: [CardModel] = []
    @Published public var recentMessage: [CardModel] = []
    var deviceInformation = InformationDevice()
    @Published public var supportInformation = PersonalInformationUser(email: "", uuid: "", name: "")
//    public init(dbFirestore: Firestore) {
//        self.dbFirestore = dbFirestore
//    }
    func registerUserFirebase(completion: @escaping(Result<Bool, Error>)-> ()) {
        deviceInformation.returnInformation()

        Auth.auth().createUser(withEmail: deviceInformation.email, password: deviceInformation.deviceUUID) {  authResult, error in

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
            try dbFirestore.collection(FirebaseConstants.users).document(uuid).setData(from: information)
        } catch let error {
          print("Error writing the user to Firestore: \(error)")
        }
    }

    
    func getLastChats() {
        
        guard let userUUID = Auth.auth().currentUser?.uid else { return }
        let reference = dbFirestore.collection(FirebaseConstants.lastMessages)
            .document(userUUID)
            .collection(FirebaseConstants.messages)
        
        reference.addSnapshotListener { [weak self] querySnapshot, error in
            
            guard let self = self, let querySnapshot = querySnapshot, error == nil else { return }
            
            querySnapshot.documentChanges.forEach { change in
                
                let documentId = change.document.documentID
                if let index = self.recentMessage.firstIndex(where: { $0.id == documentId}) {
                    self.recentMessage.remove(at: index)
                }
                if let message = try? change.document.data(as: MessageModel.self) {
                    let referenceSupportInformation = self.dbFirestore.collection("supports").document(documentId)
                    
                    referenceSupportInformation.getDocument(as: PersonalInformationUser.self) { result in
                        switch result {
                            case .success(let information):
                                self.supportInformation = information
                                print(self.recentMessage)
                            case .failure(let error):
                                print("ERROR GETTING SUPPOR INFORMATION \(error)")
                        }
                    }
                    self.recentMessage.insert(CardModel(id: message.id ?? "1", titleFormat: TextViewModel(text: message.message, foregroundColor: .black, font: .system(size: 14), expandable: false), dateFormat: TextViewModel(text: "\(message.timestamp.dateValue().formatted(date: .numeric, time: .shortened))", foregroundColor: .gray, font: .system(size: 11), expandable: false), nameFormat:  TextViewModel(text: message.fromName, foregroundColor: .black, font: .system(size: 13, weight: .bold), expandable: false) , designCard: ComponentDesign(backgroundColor: .gray.opacity(0.1), cornerRaiuds: 15),fromUUID: message.fromUUID ,toUUID: message.toUUID, action: "chat"), at: 0)
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
    func getArticles(completion: @escaping(Result<[InformationCardApi], Error>) -> Void) {
        let reference = dbFirestore.collection(CommonStrings.ArticlesStringApi.articles).document(CommonStrings.ArticlesStringApi.help)
        
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
        
        articlesHelp.forEach { information in
            self.articles.append(CardModel(id: information.id, image: ImageModel(image: information.image?.image ?? "", backgroundColor: Color(hex: information.image?.backgroundColor ?? "")), link: information.link, titleFormat: TextViewModel(text: information.titleFormat.text, foregroundColor: Color(hex: information.titleFormat.foregroundColor), font: Font.system(size: information.titleFormat.fontSize.parseToCGFloat()), expandable: information.titleFormat.expandable ?? false), dateFormat: TextViewModel(text: information.dateFormat?.text ?? "", foregroundColor: Color(hex: information.dateFormat?.foregroundColor ?? "#000000"), font: Font.system(size: information.dateFormat?.fontSize.parseToCGFloat() ?? 0), expandable: information.dateFormat?.expandable ?? false) , designCard: ComponentDesign(backgroundColor: Color(hex: information.designCard?.backgroundColor ?? "#DAF1F0"), cornerRaiuds: information.designCard?.cornerRaiuds?.parseToCGFloat() ?? 15), action: information.action ?? ""))
        }
    }
}
