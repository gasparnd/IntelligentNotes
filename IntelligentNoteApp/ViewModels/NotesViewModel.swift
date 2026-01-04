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
    
    func getNoteBy(id: UUID) -> Note? {
        if let note = notes.first(where: { $0.id == id }) {
            return note
        }
        return nil
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
        let note = getNoteBy(id: id)
        guard let note else {
            return false
        }
        
        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("\(note.title).txt")
            
            try note.body.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            return false
        }
        
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
    
    func analyzeWith(command: String, noteBody: String) async throws -> String {
        let (availability, reason) = checkForSystemLanguageModelAvailability()
        
        if !availability {
            return reason
        }
        
        let session = LanguageModelSession()
        
        let prompt = """
        Please respond in the language of the request and the entry; if that's not possible, use English. This is the full entry; use it for context to help you provide the best response if the request requires it.
        =================
        Entry: \(noteBody)
        =================
        Prompt: \(command)
        =================
        """
        
        do {
            let response = try await session.respond(to: prompt)
            return response.content
        } catch {
            print("Error responding \(error.localizedDescription)")
            if let _ = error as? FoundationModels.LanguageModelSession.GenerationError {
                return "Sorry we cannot help you with that"
            }
            return "Error responding"
        }
    }
}
