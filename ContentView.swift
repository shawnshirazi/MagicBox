//
//  ContentView.swift
//  MagicBox
//
//  Created by Shawn Shirazi on 1/3/23.
//

import SwiftUI
import CoreData


struct ContentView: View {
    //@Environment(\.managedObjectContext) private var viewContext
    let persistentContainer = CoreDataManager.shared.persistenceContainer
    var bleManager: BLEManager
    
//    var executionService: CommandExecutionService
    var compassHeading: CompassHeading

    
//    @StateObject executionService = CommandExecutionService(peripheral: BLEManager., bleManager: T##BLEManager)
    
//    @ObservedObject var bleManager = BLEManager()
    
    init(){
        bleManager = BLEManager()
//        executionService = CommandExecutionService(bleManager: bleManager)
        compassHeading = CompassHeading()
        
    }

    var body: some View {
        
        TabView {
            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "list.dash")
                }
            
            MessageHomeView()
                .tabItem {
                    Label("Messages", systemImage: "list.dash")
                }
        }
        .environmentObject(bleManager)
//            .environmentObject(executionService)
        .environmentObject(compassHeading)

//        ScanView()
//            .environmentObject(bleManager)
////            .environmentObject(executionService)
//            .environmentObject(compassHeading)

    }
}


//struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()
//
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
