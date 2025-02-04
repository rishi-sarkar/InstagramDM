//
//  InstaDMApp.swift
//  InstaDM
//
//  Created by Rishi Sarkar on 2025-02-04.
//

import SwiftUI

@main
struct InstaDMApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
