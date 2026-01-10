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
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

    @StateObject private var model: NotesViewModel
    private let modelContainer: ModelContainer
    
    init() {
        print("hola")
        do {
            let container = try ModelContainer(for: NoteModel.self)
            let context = container.mainContext
            let dataSource = LocalDataSource(context: context)
            _model = StateObject(wrappedValue: NotesViewModel(dataSource: dataSource))
            self.modelContainer = container
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }.modelContainer(for: [NoteModel.self])
    }
}
