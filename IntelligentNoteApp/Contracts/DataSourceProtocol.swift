//
//  DataSourceProtocol.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 04-01-26.
//

import Foundation

protocol DataSourceProtocol {
    /// Get Notes
    func getNotes() -> [Note]
    /// Create Note
    func createNote(from: Note)
    /// Update Note
    func updateNote(id: UUID, with: Note)
    /// Delete Note
    func deleteNote(id: UUID)
}
