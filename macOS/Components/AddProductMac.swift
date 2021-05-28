//
//  AddProductMac.swift
//  MultiplatformChallenge (macOS)
//
//  Created by David Augusto on 26/05/21.
//

import SwiftUI

struct AddProductMac: View {
    @State var nameItem = ""
    @State var priceItem = 0.0
    @State var quantityItem = 1
    @StateObject var shoppingListVM: ShoppingListViewModel

    @Binding var showModal: Bool
    @Binding var isEdit: Bool
    var item: ProductItem?

    var body: some View {
        let titleFont = Font.custom(FontNameManager.Poppins.bold, size: 22)
        let textFont = Font.custom(FontNameManager.Poppins.regular, size: 17)
        VStack {
            HStack {
                Text(isEdit ? "Editar Produto" : "Adicionar Produto")
                    .font(titleFont)
                Spacer()
            }
            .padding(.bottom, 35)

            //Components
            TextFieldModalView(nameText: $nameItem,
                               title: "Produto",
                               placeholder: "Ex.: Arroz branco",
                               titleFont: textFont)
            CurrencyTextFieldModalView(valueFinal: $priceItem,
                                       hasTitle: true,
                                       title: "Preço")
            QuantityModalView(quantity: $quantityItem,
                              title: "Quantidade",
                              backgroundRectangleColor: Color( "ActionColorSecond"))
            HStack {
                ButtonModalView(foregrounColor: .black, backgroundColor: .clear, titleButton: "Cancelar", actionButton: {showModal = false})
                ButtonModalView(foregrounColor: .black, backgroundColor: Color("AccentColor"), titleButton: isEdit ? "Salvar" : "Adicionar", actionButton: {
                    if isEdit {
                        editItem()
                    } else {
                        addItem()
                    }
                    showModal = false
                })
            }
            .padding(.top, 40)

        }
        .onAppear {
            self.nameItem = item?.name ?? ""
            self.quantityItem = Int(item?.quantity ?? 0)
            self.priceItem = Double(item?.price ?? 0.00)
            print("::::::::::::::isEdit \(isEdit)")
        }
        .padding(.horizontal, 30)
        .buttonStyle(BorderlessButtonStyle())
        .frame(width: 430, height: 420, alignment: .center)
        .background(Color.white)
        .foregroundColor(Color.black)
        .font(textFont)
        .textFieldStyle(PlainTextFieldStyle())
    }

    func addItem() {
        shoppingListVM.name = nameItem
        shoppingListVM.quantity = Int16(quantityItem)
        shoppingListVM.price = Float(priceItem)
        shoppingListVM.isChecked = false
        shoppingListVM.save()
        shoppingListVM.getAllItens()
    }
    func editItem() {
        guard let item = item else {return}
        shoppingListVM.name = nameItem
        shoppingListVM.quantity = Int16(quantityItem)
        shoppingListVM.price = Float(priceItem)
        shoppingListVM.isChecked = item.isChecked
        shoppingListVM.upDate(id: item.id)
        shoppingListVM.getAllItens()
    }
}


//struct AddProductMac_Previews: PreviewProvider {
//    static var previews: some View {
//        AddProductMac(showModal: .constant(true), shoppingListVM: <#ShoppingListViewModel#>)
//    }
//}
