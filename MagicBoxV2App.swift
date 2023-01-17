//
//  MagicBoxV2App.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/5/23.
//

import SwiftUI

@main
struct MagicBoxV2App: App {
    let persistentContainer = CoreDataManager.shared.persistenceContainer

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
