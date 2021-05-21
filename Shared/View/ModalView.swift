import SwiftUI
import Combine
import UIKit

public struct ModalView<Content: View>: View {
    @State var offset = UIScreen.main.bounds.height
    @Binding var isShowing: Bool
    
    let heightToDisappear = UIScreen.main.bounds.height
    let cellHeight: CGFloat = 50
    let backgroundColor: Color
    
    var isTitleLarge: Bool
    var titleModal: String
    var titleButtonRight: String
    var titleButtonLeft: String
    let content: Content
    
    public init(isShowing: Binding<Bool>,
                backgroundColor: Color = Color.white,
                isTitleLarge: Bool,
                titleModal: String,
                titleButtonLeft: String = "Cancelar",
                titleButtonRight: String = "Adicionar",
                @ViewBuilder contentBuilder: () -> Content) {
        _isShowing = isShowing
        self.backgroundColor = backgroundColor
        self.isTitleLarge = isTitleLarge
        self.titleModal = titleModal
        self.content = contentBuilder()
        self.titleButtonLeft = titleButtonLeft
        self.titleButtonRight = titleButtonRight
    }
    
    func hide() {
        offset = heightToDisappear
        isShowing = false
    }
    
    var dragGestureDismissModal: some Gesture {
        DragGesture()
            .onChanged({ (value) in
                if value.translation.height > 0 {
                    offset = value.location.y
                }
            })
            .onEnded({ (value) in
                let diff = abs(offset-value.location.y)
                if diff > 100 {
                    hide()
                } else {
                    offset = 0
                }
            })
    }
    
    var backgroundAreaView: some View {
        Group {
            if isShowing {
                BackgroundModalView {
                    self.hide()
                }
            }
        }
    }
    
    var sheetView: some View {
        VStack {
            Spacer()
            VStack {
                HeaderModalView(titleModal: titleModal,
                                isTitleLarge: isTitleLarge)
                content
                    .padding(.top, 30)
                Text("").frame(height: 50)
            }
            .background(backgroundColor)
            .cornerRadius(15)
            .offset(y: offset)
            .gesture(dragGestureDismissModal)
        }
    }
    
    var bodyContet: some View {
        ZStack {
            backgroundAreaView
            sheetView
        }
    }
    
    public var body: some View {
        Group {
            if isShowing {
                bodyContet
            }
        }
        .animation(.default)
        .onReceive(Just(isShowing), perform: { isShowing in
            offset = isShowing ? 0 : heightToDisappear
        })
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            ModalView(isShowing: .constant(true),
                      isTitleLarge: false,
                      titleModal: "Adicionar Produto",
                      contentBuilder: {
                        VStack {
                            TextFieldModalView(title: "Nome",
                                               placeholder: "Ex.: Arroz branco")
                                .frame(height: 50)
                            CurrencyTextFieldModalView(title: "Preço")
                                .frame(height: 50)
                        }
                    })
        }
    }
}
