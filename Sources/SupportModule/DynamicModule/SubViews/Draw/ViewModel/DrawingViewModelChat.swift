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
    let uuid = UUID().uuidString
    let storage = Storage.storage()
    var downloadURL: URL?
    
    public init(messageModel: MessageModel) {
        self.messageModel = messageModel
    }
    
    func saveImageToPhotoLibrary(_ image: UIImage, lines: [LineModel]) async {
        guard let fromUUID = FirebaseManagerData.initialization.dbAuth.currentUser?.uid else { return }
        let chat = FormTypeMessageViewModel(toUUID: messageModel.fromUUID, messageModel: messageModel)
        let storageRef = storage.reference()

        do {
            let downloadURL = try await uploadImage(image: image, storageRef: storageRef)

            let option = [OptionsMessage(id: UUID().uuidString, lines: lines)]
            await chat.sendMessage(message: "\(downloadURL)", type: TypeMessage.image.rawValue, options: option) { completion in
                switch completion {
                    case .success(let success):
                        print(success)
                        await chat.updateMessage(message: self.messageModel.message, type: TypeMessage.signature.rawValue, options: option) { completion in
                            switch completion {
                                case .success(let success):
                                    print(success)
                                case .failure(let failure):
                                    print(failure)
                            }
                        }
                    case .failure(let failure):
                        print(failure)
                }
            }
            print("IMAGEN GUARDADA")
        } catch {
            print(error)
        }
    }
    
    func uploadImage(image: UIImage, storageRef: StorageReference) async throws -> URL {
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("messageImage/\(uuid).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { throw URLError(.fileDoesNotExist) }

        let uploadMeta = StorageMetadata()
        uploadMeta.contentType = "image/jpg"

        do {
            riversRef.putData(imageData, metadata: uploadMeta)

            let url = try await riversRef.downloadURL()

            return url

        } catch {
            throw error
        }
    }
    
//    func uploadImage(image:UIImage, storageRef: StorageReference) {
//        // Create a reference to the file you want to upload
//        let riversRef = storageRef.child("messageImage/\(uuid).jpg")
//        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
//        let uploadMeta = StorageMetadata.init()
//        uploadMeta.contentType = "image/jpg"
//        
//        let uploadTask = riversRef.putData(imageData, metadata: uploadMeta) { (metadata, error) in
//            guard let metadata = metadata else {
//                print("error al subir la imagen")
//                return
//            }
//            riversRef.downloadURL { (url, error) in
//                guard let url = url else {
//                    //aqui el error
//                    return
//                }
//                downloadURL = url
//            }
//        }
//    }
    func showLineasFromMessage() {
        guard let options = messageModel.options else { return }
        options.forEach { optionMessage in
            
        }
    }
}
