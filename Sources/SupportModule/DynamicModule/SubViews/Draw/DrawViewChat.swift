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
    @State public var lines: [LineModel] = []
    @State var drawing: DrawingView? = nil
    public init(image: Binding<UIImage?>, messageModel: MessageModel) {
        self._image = image
        self.messageModel = messageModel
        self._viewModel = StateObject(wrappedValue: DrawingViewModelChat(messageModel: messageModel))
    }
    var body: some View {
        
        VStack {
            drawing
                .frame(width: 300, height: 300, alignment: .center)
            if image != nil {
                let _ = asyncTaskCaller()
            }
        }
        
        .onAppear {

            putLines()
            self.drawing = DrawingView(activeLineWidth: false, multipleColor: false, colors: [.black], uiimage: self.$image, lines: self.$lines)
        }
    }
    
    func putLines() {
        guard let options = messageModel.options, let firstOption = options.first, let lines = firstOption.lines else  { return }
        let arrayPoints = lines.points.map { point in
            return CGPoint(x: Double(point.x) ?? 0.0, y: Double(point.y) ?? 0.0)
        }
        let lineModel = LineModel(points: arrayPoints, color: .black, lineWidth: lines.lineWidth)
        self.lines = [lineModel]
    }
    
    func asyncTaskCaller() {
        Task {
            await viewModel.saveImageToPhotoLibrary(image!, lines: lines)
        }
    }
}

//#Preview {
//    DrawViewChat(image: .constant(nil))
//}

