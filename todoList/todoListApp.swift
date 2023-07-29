//
//  todoListApp.swift
//  todoList
//
//  Created by Kesavan Panchabakesan on 29/07/23.
//

import SwiftUI

@main
struct todoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
