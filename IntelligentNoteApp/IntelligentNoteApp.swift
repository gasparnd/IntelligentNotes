//
//  IntelligentNoteApp.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 02-01-26.
//

import SwiftUI
import SwiftData

@main
struct IntelligentNoteAppApp: App {
    
    init() {
        do {
            let container = try ModelContainer(for: NoteModel.self)
            let context = container.mainContext
            let dataSource = LocalDataSource(context: context)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
