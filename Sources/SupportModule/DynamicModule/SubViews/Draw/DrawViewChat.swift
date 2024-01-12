//
//  DrawViewChat.swift
//
//
//  Created by Danilo Hernandez on 12/01/24.
//

import SwiftUI
import Drawing

struct DrawViewChat: View {
    
    @Binding public var image: UIImage?
    public var messageModel: MessageModel
    @StateObject var viewModel: DrawingViewModelChat
    public init(image: Binding<UIImage?>, messageModel: MessageModel) {
        self._image = image
        self.messageModel = messageModel
        self._viewModel = StateObject(wrappedValue: DrawingViewModelChat(messageModel: messageModel))
    }
    var body: some View {
        
        DrawingView(activeLineWidth: false, multipleColor: false, colors: [.black], uiimage: $image)
            .frame(width: 300, height: 300, alignment: .center)
        if image != nil {
            let _ = viewModel.saveImageToPhotoLibrary(image!)
        }
    }
}

//#Preview {
//    DrawViewChat(image: .constant(nil))
//}
import FirebaseStorage
public class DrawingViewModelChat : ObservableObject {
    
    public var messageModel: MessageModel
    
    public init(messageModel: MessageModel) {
        self.messageModel = messageModel
    }
    
    func saveImageToPhotoLibrary(_ image: UIImage) {
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
                print(downloadURL)
            }
        }
    }
    
}
