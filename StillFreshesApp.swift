import SwiftUI

// Root view you can present from your existing @main App file.
struct StillFreshesRootView: View {
    @StateObject private var store = ItemStore()

    var body: some View {
        ItemListView()
            .environmentObject(store)
            .task { await NotificationManager.shared.requestAuthorizationIfNeeded() }
    }
}

#Preview {
    StillFreshesRootView()
}
