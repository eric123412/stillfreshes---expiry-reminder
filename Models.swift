import Combine
import Foundation

struct ExpiryItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var expiryDate: Date
}

@MainActor
final class ItemStore: ObservableObject {
    @Published private(set) var items: [ExpiryItem] = []

    private let storageKey = "expiry_items_storage"

    init() {
        load()
    }

    func add(name: String, expiryDate: Date) {
        let new = ExpiryItem(name: name, expiryDate: expiryDate)
        items.append(new)
        save()
        NotificationManager.shared.scheduleReminder(for: new)
    }

    func remove(at offsets: IndexSet) {
        let removed = offsets.map { items[$0] }
        items.remove(atOffsets: offsets)
        save()
        for item in removed {
            NotificationManager.shared.cancelReminder(for: item)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        if let decoded = try? JSONDecoder().decode([ExpiryItem].self, from: data) {
            items = decoded
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
