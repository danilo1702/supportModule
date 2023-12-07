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
    
    
    func getAvailableSupports(completion: @escaping (Result<String, Error>) -> ()) {
        let reference = dbFirestore.collection(FirebaseConstants.supports)
        
        reference.whereField(FirebaseConstants.busy, isEqualTo: false).addSnapshotListener { querySnapshot, error in
            
            guard let queryDocument = querySnapshot, let fromUUID = Auth.auth().currentUser?.uid, error == nil else { return }
            if let support = try? queryDocument.documentChanges.first?.document.data(as: PersonalInformationUser.self) {
                completion(.success(support.uuid))
            }else {
                completion(.failure(NSError(domain: "There isn't a support user", code: 204)))
            }
 
        }
        
    }
    
}
