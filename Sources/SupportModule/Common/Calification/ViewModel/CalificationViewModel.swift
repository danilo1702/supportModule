//
//  CalificationViewModel.swift
//
//
//  Created by Danilo Hernandez on 15/12/23.
//

import Foundation
import SwiftUI


public class CalificationViewModel: ObservableObject {
    
    @Published public var optionsCalification: [OptionsCalification] = []
    
    func getOptions() {
        
        let reference = FirebaseManagerData.initialization.dbFirestore.collection("optionsCalification")
        reference.getDocuments { [weak self] querySnapshot, error in
            guard let self = self, let querySnapshot = querySnapshot, error == nil else { return }
            
            querySnapshot.documents.forEach { document in
                if let document = try? document.data(as: InformationCardApi.self) {
                    self.optionsCalification.append(OptionsCalification(selected: false, model: document.convertToCardModel()))
                }
            }
        }
    }
    func getImage(completion: @escaping (Result<String, Never>) -> ()) {
        FirebaseManagerData.initialization.dbRemoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote {
                if let companyLogo = FirebaseManagerData.initialization.dbRemoteConfig["companyLogo"].stringValue {
                    completion(.success(companyLogo))
                }
            }
        }
    }
    func sendInformation(information: SendCalification, toUUID: String, completion: @escaping (Result<Bool, Never>) -> ()) {
        guard let uuid = FirebaseManagerData.initialization.dbAuth.currentUser?.uid else { return }
        let reference = FirebaseManagerData.initialization.dbFirestore.collection(FirebaseConstants.closedChats).document(uuid).collection(FirebaseConstants.messages).document(toUUID)
        
        if let result = try? reference.setData(from: information) {
            completion(.success(true))
        } else {
            completion(.success(true))
        }
    }
}
