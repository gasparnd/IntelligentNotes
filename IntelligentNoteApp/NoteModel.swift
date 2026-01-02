//
//  NoteModel.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 02-01-26.
//

import Foundation

struct Note: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var body: String
}
