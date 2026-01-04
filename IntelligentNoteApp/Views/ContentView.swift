//
//  ContentView.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 02-01-26.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: NotesViewModel
    @State private var selectedNote: Note?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedNote) {
                Section("Notes") {
                    ForEach(model.notes) { note in
                        Text(note.title)
                            .tag(note)
                    }
                }
            }
        } detail: {
            if let note = selectedNote {
                NoteView(note: binding(for: note))
            } else {
                Text("Select or create a note")
                    .foregroundStyle(.secondary)
            }
        }
        .toolbar {
            Button(action: didClickAddNote) {
                Image(systemName: "square.and.pencil")
            }
        }
        .navigationTitle("Intgelligent Notes")
        .onAppear {
            model.getNotes()
        }
    }
}

extension ContentView {
    private func binding(for note: Note) -> Binding<Note> {
        guard let index = model.notes.firstIndex(where: { $0.id == note.id }) else {
            fatalError()
        }
        return $model.notes[index]
    }
    
    private func didClickAddNote() {
        let newNote = Note(title: "New story", body: "Write here...")
        model.createNote(from: newNote)
        selectedNote = newNote
    }
}

#Preview {
    ContentView()
}
