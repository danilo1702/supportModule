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
import Combine

public class DrawingViewModelChat : ObservableObject {
    
    public var messageModel: MessageModel
    var uploadedImage = PassthroughSubject<(URL, [LineModel]), Error> ()
    var cancellable = Set<AnyCancellable>()
    
    public init(messageModel: MessageModel) {
        self.messageModel = messageModel
        configureSubscriber()
    }
    
    func configureSubscriber() {
       
        let chat = FormTypeMessageViewModel(toUUID: messageModel.fromUUID, messageModel: messageModel)
        uploadedImage.sink { completion in
            switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
            }
        } receiveValue: { (url, lines) in
            let option = [OptionsMessage(id: UUID().uuidString, lines: lines)]
            Task {
                await chat.sendMessage(message: "\(url)", type: TypeMessage.image.rawValue, options:  option) { result in
                    switch result {
                        case .success(let success):
                            print("IMAGEN GUARDADA \(success)")
                            
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
            }
        }.store(in: &cancellable)
    }
    
    func saveImageToPhotoLibrary(_ image: UIImage, lines: [LineModel]) async {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let uuid = UUID().uuidString
        
        let riversRef = storageRef.child("messageImage/\(uuid).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else{ return }
        let uploadMeta = StorageMetadata.init()
        uploadMeta.contentType = "image/jpg"
        
          riversRef.putData(imageData, metadata: uploadMeta) { (metadata, error) in
            guard error == nil else {
                print("error al subir la imagen")
                return
            }
            riversRef.downloadURL { (url, error) in
                guard let url = url else {
                    print("error downloadURL \(String(describing: error)) *******-**  \(String(describing: error?.localizedDescription))")
                    return
                }
                self.uploadedImage.send((url, lines))
            }
        }
    }
    
    
    
    func uploadImage(image:UIImage, storageRef: StorageReference, uuid: String) {
        
        
    }
    func showLineasFromMessage() {
        guard let options = messageModel.options else { return }
        options.forEach { optionMessage in
            
        }
    }
}
