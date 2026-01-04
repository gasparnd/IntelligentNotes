//
//  ViewModelProtocol.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 04-01-26.
//

import Foundation

protocol ViewModelProtocol: ObservableObject {
    /// Get Notes
    func getNotes()
    /// Create Note
    func createNote(from: Note)
    /// Update Note
    func updateNote(id: UUID, with: Note)
    /// Delete Note
    func deleteNote(id: UUID)
    /// Donwload Note
    func downloadNote(id: UUID) -> Bool
}
