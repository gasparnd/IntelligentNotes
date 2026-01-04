//
//  LocalDataSource.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 04-01-26.
//

import Foundation
import SwiftData

class LocalDataSource: DataSourceProtocol {
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
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
    
    func updateNote(id: UUID, with: Note) {
        let descriptor = FetchDescriptor<NoteModel>(
            predicate: #Predicate<NoteModel> { $0.id == id }
        )
        
        do {
            let results = try context.fetch(descriptor)
            guard let noteToUpdate = results.first else {
                print("❌ Note with id \(id) not found")
                return
            }
            
            noteToUpdate.title = with.title
            noteToUpdate.body = with.body
            
            try context.save()
            print("✅ Note updated successfully with id: \(id)")
        } catch {
            print("❌ Error updating Note from SwiftData: \(error)")
        }
    }
    
    func deleteNote(id: UUID) {
        let descriptor = FetchDescriptor<NoteModel>(
            predicate: #Predicate<NoteModel> { $0.id == id }
        )
        
        do {
            let results = try context.fetch(descriptor)
            guard let noteToDelete = results.first else {
                print("❌ Note with id \(id) not found")
                return
            }
            
            context.delete(noteToDelete)
            try context.save()
            print("✅ Note deleted successfully with id: \(id)")
        } catch {
            print("❌ Error deleting Note from SwiftData: \(error)")
        }
    }
    
}
