import SwiftUI

struct ListRow: View {

    let item: ProductItem
    @State var checkState: Bool = false
    @Binding var isShowingWithoutPriceModal: Bool
    @Binding var isShowingLimitModal: Bool
    @Binding var isShowDeleteConfirmation: Bool
    var action: () -> Void
    @ObservedObject var shoppingListVM: ShoppingListViewModel

    func checkItem() {
        var newItem = ItemList()
        newItem.name = item.name
        newItem.price = item.price
        newItem.quantity = item.quantity
        newItem.isChecked = checkState
        shoppingListVM.update(updatedList: newItem, id: item.id)
        shoppingListVM.getAllItens()
    }

    var checkboxFieldView: some View {
         Button(action: {
            if item.price == 0.0 && !item.isChecked {
                action()
                self.isShowingWithoutPriceModal.toggle()
            } else if (calculateSum() + Double(item.price * Float(item.quantity))) > (shoppingListVM.list.first?.budget ?? 0.00) && !item.isChecked {
                action()
                if calculateSum() <= (shoppingListVM.list.first?.budget ?? 0.00) {
                    self.isShowingLimitModal.toggle()
                } else {
                    self.checkState = !item.isChecked
                    checkItem()
                }
            } else {
                self.checkState = !item.isChecked
                checkItem()
            }
        }) {
            if item.isChecked {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("AccentColor"))
            } else {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .shadow(radius: 2)
            }
        }
        .foregroundColor(Color.white)
        .buttonStyle(PlainButtonStyle())
    }

    func calculateSum() -> Double {
     var totalSum: Double = 0.00
     shoppingListVM.itens.forEach { item in
         if item.isChecked {
             totalSum += Double((item.price * Float(item.quantity)))
         }
     }
     return totalSum
    }

    var body: some View {
        HStack {
            checkboxFieldView
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(FontNameManager.CustomFont.titleComponentFont)
                Text("\(item.quantity) unidades")
                    .font(Font.custom(FontNameManager.Poppins.regular, size: 17))
                    .foregroundColor(Color("TextColor"))
            }
            Spacer()
            VStack {
                Text("R$ \(String(format: "%.2f", (item.price*Float(item.quantity))))")
                    .font(FontNameManager.CustomFont.titleComponentFont)
                Text("\(item.quantity) x R$\(String(format: "%.2f", item.price))")
                    .font(Font.custom(FontNameManager.Poppins.regular, size: 12))
                    .foregroundColor(Color("TextColor"))
            }
            #if os(macOS)
            Text("").frame(width: 20)
            Image(systemName: "trash")
                    .font(.system(size: 25))
                    .background(Color.clear)
                    .foregroundColor(Color("PlaceholderColor"))
                    .border(Color.clear, width: 0)
                    .onTapGesture {
                        action()
                        isShowDeleteConfirmation.toggle()
                    }
            #endif
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(self.item.isChecked ? Color("ActionColorSecond") : Color.white).shadow(radius: self.item.isChecked ? 0 : 1))

    }
}
