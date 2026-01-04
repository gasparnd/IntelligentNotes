//
//  NotesViewModel.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 04-01-26.
//

import Foundation
import FoundationModels
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
        let storedNotes = dataSource.getNotes()
        notes = storedNotes
    }
    
    func downloadNote(id: UUID) -> Bool {
        return false
    }
    
    private func checkForSystemLanguageModelAvailability() -> (avaliavle: Bool, reason: String) {
        let model = SystemLanguageModel.default
        
        switch model.availability {
        case .available:
            return (true , "")
        case .unavailable(.modelNotReady):
            return (false , "Apple Intelligence is not ready yet")
        case .unavailable(.appleIntelligenceNotEnabled):
            return (false , "Apple Intelligence is not enabled. Please turn on it before continue")
        case .unavailable(.deviceNotEligible):
            return (false , "Sorry it seems that your systems is not eligible to perform this task.")
        default:
            return (false , "Sorry it seems that your systems is not able to perform this task.")
        }
    }
    
    func analyzeWith(command: String) -> String {
        let (availability, reason) = checkForSystemLanguageModelAvailability()
        
        if !availability {
            return reason
        }
        
        return "This is the result of the think: command!"
    }
}
