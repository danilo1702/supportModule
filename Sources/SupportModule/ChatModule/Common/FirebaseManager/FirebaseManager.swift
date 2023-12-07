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

public class FirebaseManagerData {
    
     var dbAuth: Auth
     var dbFirestore: Firestore
     var currentUser: CurrentUserData?
    
    static let initialization = FirebaseManagerData()
    
     public init() {
    
        self.dbAuth = Auth.auth()
        self.dbFirestore = Firestore.firestore()
        
    }
}


