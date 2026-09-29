import SwiftUI

struct ItemListView: View {
    @EnvironmentObject private var store: ItemStore
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            Group {
                if store.items.isEmpty {
                    ContentUnavailableView("No items yet", systemImage: "leaf", description: Text("Add your food or products and we'll remind you 3 days before they expire."))
                } else {
                    List {
                        ForEach(store.items) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.expiryDate, style: .date)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                DaysBadge(expiry: item.expiryDate)
                            }
                        }
                        .onDelete(perform: store.remove)
                    }
                }
            }
            .navigationTitle("StillFreshes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddItemView()
                    .environmentObject(store)
            }
        }
    }
}

struct DaysBadge: View {
    let expiry: Date
    var daysRemaining: Int {
        let start = Calendar.current.startOfDay(for: .now)
        let end = Calendar.current.startOfDay(for: expiry)
        let comps = Calendar.current.dateComponents([.day], from: start, to: end)
        return comps.day ?? 0
    }
    var body: some View {
        let days = daysRemaining
        Text("\(days)d")
            .font(.caption).bold()
            .padding(6)
            .background(days <= 0 ? .red.opacity(0.2) : (days <= 3 ? .orange.opacity(0.2) : .green.opacity(0.2)))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .foregroundStyle(days <= 0 ? .red : (days <= 3 ? .orange : .green))
            .accessibilityLabel("\(days) days remaining")
    }
}

#Preview {
    ItemListView()
        .environmentObject(ItemStore())
}
