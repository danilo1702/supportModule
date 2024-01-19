//
//  DrawingViewModelChat.swift
//
//
//  Created by Danilo Hernandez on 17/01/24.
//

import Foundation
import FirebaseStorage
import SwiftUI
import Drawing

public class DrawingViewModelChat : ObservableObject {
    
    public var messageModel: MessageModel
    
    public init(messageModel: MessageModel) {
        self.messageModel = messageModel
    }
    
    func saveImageToPhotoLibrary(_ image: UIImage, lines: [LineModel]) {
        
        guard let fromUUID = FirebaseManagerData.initialization.dbAuth.currentUser?.uid else { return }
        let chat = FormTypeMessageViewModel(toUUID: messageModel.fromUUID)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let uuid = UUID().uuidString
        
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("messageImage/\(uuid).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let uploadMeta = StorageMetadata.init()
        uploadMeta.contentType = "image/jpg"
        
        let uploadTask = riversRef.putData(imageData, metadata: uploadMeta) { (metadata, error) in
            guard let metadata = metadata else {
                print("error al subir la imagen")
                return
            }
           
            
            let size = metadata.size
            
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    //aqui el error
                    return
                }
                let option = [OptionsMessage(id: UUID().uuidString, lines: lines)]
                
                chat.sendMessage(message: "\(downloadURL)", type: TypeMessage.image.rawValue, options:  option) { result in
                    switch result {
                        case .success(let success):
                            print("IMAGEN GUARDADA")
                        case .failure(let failure):
                            print(failure)
                    }
                }
            }
        }
    }
    func showLineasFromMessage() {
        guard let options = messageModel.options else { return }
        options.forEach { optionMessage in
            
        }
    }
}
