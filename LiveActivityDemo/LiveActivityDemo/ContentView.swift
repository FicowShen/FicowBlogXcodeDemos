import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var paused = false

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: startActivity) {
                        Text("Start")
                    }
                }
                ToolbarItem {
                    Button(action: updateActivity) {
                        Text("Update")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: stopActivity) {
                        Text("Stop")
                    }
                }
            }
            Text("Select an item")
        }
    }

    func startActivity() {
        ActivityController.shared.startLiveActivity(attributes: .init(id: "ficow test"), initialState: .init(text: "S", endTime: .init(timeIntervalSinceNow: 10)), staleDate: nil, relevanceScore: 50)
    }

    func updateActivity() {
        Task { @MainActor in
            try await ActivityController.shared.updateActivity(state: .init(text: paused ? "P" : "U", pauseTime: paused ? .now : nil), staleDate: .init(timeIntervalSinceNow: 10), alert: .some((title: "alert title", body: "body")))
            paused.toggle()
        }
    }

    func stopActivity() {
        ActivityController.shared.endActivity(
            finalState: .init(text: "E"),
            dismissalPolicy: .immediate
        )
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

