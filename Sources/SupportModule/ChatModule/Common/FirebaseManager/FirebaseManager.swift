//
//  FirebaseManager.swift
//
//
//  Created by Danilo Hernandez on 7/12/23.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

public class FirebaseManagerData: ObservableObject {
    
    @Published var dbAuth: Auth
    @Published var dbFirestore: Firestore
    @Published var currentUser: CurrentUserData?
    
    let initialization = FirebaseManagerData()
    
     init() {
    
        self.dbAuth = Auth.auth()
        self.dbFirestore = Firestore.firestore()
        
    }
}


