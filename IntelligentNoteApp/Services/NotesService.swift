//
//  NotesService.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 10-01-26.
//

import Foundation
import SwiftData

final class NotesService {
    static let shared = NotesService()
    
    private let container: ModelContainer
    private let context: ModelContext
    
    private init() {
        self.container = try! ModelContainer(for: NoteModel.self)
        self.context = container.mainContext
    }
    
    func getNotes() -> [Note] {
        let descriptor = FetchDescriptor<NoteModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        do {
            let models = try context.fetch(descriptor)
            return models.map { $0.toNote() }
        } catch {
            print("❌ Error fetching configurations from SwiftData: \(error)")
            return []
        }
    }
    
    func createNote(from note: Note) {
        let newNote = NoteModel(
            id: note.id,
            title: note.title,
            body: note.body,
            createdAt: note.createdAt
        )
        
        context.insert(newNote)
        
        do {
            try context.save()
        } catch {
            print("❌ Error saving to SwiftData: \(error)")
        }
    }
}
