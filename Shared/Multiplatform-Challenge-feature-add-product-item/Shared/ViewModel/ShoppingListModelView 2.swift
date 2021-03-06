import Foundation
import CoreData

class ShoppingListViewModel: ObservableObject {

    var name: String = ""
    var quantity: Int16 = 0
    var prince: Float = 0.00
    var isChecked: Bool = false

    @Published var itens: [ProductItem] = []

    func getAllItens() {
        itens = CoreDataManager.shared.getAllItens().map(ProductItem.init)
    }

    func delete(_ item: ProductItem) {
        let existingItem = CoreDataManager.shared.getItemById(id: item.id)
        if let existingItem = existingItem {
            CoreDataManager.shared.deleteItem(item: existingItem)
        }
    }

    func save() {
        let item = Item(context: CoreDataManager.shared.viewContext)
        item.name = name

        CoreDataManager.shared.save()
    }

}
