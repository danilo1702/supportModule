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

    var body: some View {
        
        DrawingView(activeLineWidth: false, multipleColor: false, colors: [.black], uiimage: $image)
            .frame(width: 300, height: 300, alignment: .center)
        if image != nil {
            Image(uiImage: image!)
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
        }
    }
}

#Preview {
    DrawViewChat(image: .constant(nil))
}
