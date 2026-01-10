//
//  HotKeyManager.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 09-01-26.
//

import Foundation

final class HotKeyManager {
    static let shared = HotKeyManager()

    func trigger() {
        showQuickNote()
    }

    private func showQuickNote() {
        print("showQuickNote")
        NotesService.shared.createNote(from: Note(title: "Test short", body: "Test from shortcut"))
    }
}
