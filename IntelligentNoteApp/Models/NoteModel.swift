//
//  NoteModel.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 02-01-26.
//

import Foundation
import SwiftData

struct Note: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var body: String
    var createdAt = Date()
}


// MARK: - SwiftData Model

@Model
final class NoteModel {
    var id: UUID
    var title: String
    var body: String
    var createdAt: Date
    
    init(
        id: UUID,
        title: String,
        body: String,
        createdAt: Date
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
    }
    
    func toNote() -> Note {
        Note(
            id: self.id,
            title: self.title,
            body: self.body,
            createdAt: self.createdAt
        )
    }
}
