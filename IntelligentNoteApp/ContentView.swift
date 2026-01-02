//
//  ContentView.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 02-01-26.
//

import SwiftUI

struct ContentView: View {
    @State private var notes: [Note] = [
        Note(title: "Welcome", body: "Start writing notes here!")
    ]
    @State private var selectedNote: Note?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedNote) {
                Section("Notes") {
                    ForEach(notes) { note in
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
        }.toolbar {
            Button(action: didClickAddNote) {
                Image(systemName: "square.and.pencil")
            }
        }.navigationTitle("Intgelligent Notes")
    }
}

extension ContentView {
    private func binding(for note: Note) -> Binding<Note> {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { fatalError()
        }
        return $notes[index]
    }
    
    private func didClickAddNote() {
        let newNote = Note(title: "New story", body: "Write here...")
        notes.append(newNote)
        selectedNote = newNote
    }
}

#Preview {
    ContentView()
}
