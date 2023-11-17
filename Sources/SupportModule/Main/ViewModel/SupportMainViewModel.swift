//
//  SupportMainViewModel.swift
//  
//
//  Created by Danilo Hernandez on 30/10/23.
//

import Foundation
import FirebaseFirestore
import SwiftUI

public class SupportMainViewModel: ObservableObject {
    @Published public var dbFirestore: Firestore = Firestore.firestore()
    @Published public var articles: [CardModel] = []
    
    public init(dbFirestore: Firestore) {
        self.dbFirestore = dbFirestore
    }
    
    func getArticles(completion: @escaping(Result<[InformationCardApi], Error>) -> Void) {
        let reference = dbFirestore.collection(CommonStrings.ArticlesStringApi.articles).document(CommonStrings.ArticlesStringApi.help)
        
        reference.getDocument { snapshot, error in
            if let error = error {
                print("Error al obtener el documento: \(error)")
                completion(.failure(error))
            } else {
                if let articles = snapshot, articles.exists {
                    let decoder = Firestore.Decoder()
                    do {
                        if let data = articles.data()?[CommonStrings.ArticlesStringApi.information] as? [[String: Any]] {
                            let arrayArticle = try data.map{ try decoder.decode(InformationCardApi.self, from: $0)}
                            completion(.success(arrayArticle))
                        } else {
                            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey : "Error obteniendo la data"])))
                        }
                    } catch {
                        print("Error decoding")
                        completion(.failure(error))               
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey : "La ruta no existe"])))
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
