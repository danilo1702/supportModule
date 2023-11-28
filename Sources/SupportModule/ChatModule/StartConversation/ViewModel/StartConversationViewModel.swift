//
//  StartConversationViewModel.swift
//
//
//  Created by Danilo Hernandez on 31/10/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
public class StartConversationViewModel: ObservableObject {
    let dbFirestore = Firestore.firestore()
    
    
    func getAvailableSupports(completion: @escaping (Result<PersonalInformationUser, Error>) -> ()) {
        let reference = dbFirestore.collection(FirebaseConstants.supports)
        
        reference.whereField(FirebaseConstants.busy, isEqualTo: false).addSnapshotListener { querySnapshot, error in
            guard let queryDocument = querySnapshot, error == nil else { return }
            
            if let information = try? queryDocument.documentChanges[0].document.data(as: PersonalInformationUser.self) {
                completion(.success(information))
            } else {
                completion(.failure(NSError(domain: "There isn't a support user", code: 204)))
            }
        }
    }
    
}
