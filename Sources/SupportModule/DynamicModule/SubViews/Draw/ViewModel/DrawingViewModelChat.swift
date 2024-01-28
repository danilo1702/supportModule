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
    
    func saveImageToPhotoLibrary(_ image: UIImage, lines: [LineModel]) async {
        var downloadURL: URL?
        guard let fromUUID = FirebaseManagerData.initialization.dbAuth.currentUser?.uid else { return }
        let chat = FormTypeMessageViewModel(toUUID: messageModel.fromUUID, messageModel: messageModel)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let uuid = UUID().uuidString
        
         uploadImage(image: image, storageRef: storageRef, uuid: uuid)
//        do {
//            
//          let url =  try await uploadImage(image: image, storageRef: storageRef, uuid: uuid) { completion in
//                switch completion {
//                    case .success(let url):
//                       
//                            let option = [OptionsMessage(id: UUID().uuidString, lines: lines)]
//                                await chat.sendMessage(message: "\(url)", type: TypeMessage.image.rawValue, options:  option) { result in
//                                     switch result {
//                                         case .success(let success):
//                                             print("IMAGEN GUARDADA")
//                                             
//                                             await chat.updateMessage(message: self.messageModel.message, type: TypeMessage.signature.rawValue, options: option) { completion in
//                                                 switch completion {
//                                                     case .success(let success):
//                                                         print(success)
//                                                     case .failure(let failure):
//                                                         print(failure)
//                                                 }
//                                             }
//                                         case .failure(let failure):
//                                             print(failure)
//                                     }
//                                 }
//                       
//                    case .failure(let failure):
//                        print(failure)
//                }
//            }
//        }catch {
//            print(error)
//        }
       
       
        
         }
    
    func uploadImage(image:UIImage, storageRef: StorageReference, uuid: String)  {
        var urlImage: URL?
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("messageImage/\(uuid).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return  }
        let uploadMeta = StorageMetadata.init()
        uploadMeta.contentType = "image/jpg"
        
        let uploadTask = riversRef.putData(imageData, metadata: uploadMeta) { (metadata, error) in
            guard error == nil else {
                print("error al subir la imagen")
                return
            }
            riversRef.downloadURL { (url, error) in
                guard let url = url else {
                    //aqui el error
                    return
                }
                urlImage = url
                print("\(String(describing: urlImage))")
            }
        }
        
    }
    func showLineasFromMessage() {
        guard let options = messageModel.options else { return }
        options.forEach { optionMessage in
            
        }
    }
}
