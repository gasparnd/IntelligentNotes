//
//  ViewModel.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 04-01-26.
//

import Foundation
internal import Combine

class NotesViewModel: ViewModelProtocol {
    @Published var notes: [Note] = [
        Note(title: "Welcome", body: "Start writing notes here!")
    ]
    var dataSource: DataSourceProtocol
    
    // MARK: - Lifecycle
    
    init(dataSource: DataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func getNotes() {
        let storedNotes = dataSource.getNotes()
        notes.append(contentsOf: storedNotes)
    }
    
    func createNote(from note: Note) {
        dataSource.createNote(from: note)
        notes.append(note)
    }
    
    func updateNote(id: UUID, with note: Note) {
        dataSource.updateNote(id: id, with: note)
        if let index = notes.firstIndex(where: { $0.id == id }) {
            notes[index] = note
        }
    }
    
    func deleteNote(id: UUID) {
        dataSource.deleteNote(id: id)
        getNotes()
    }
    
    func downloadNote(id: UUID) -> Bool {
        return false
    }
}
