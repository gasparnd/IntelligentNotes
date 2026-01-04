//
//  NoteView.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 02-01-26.
//

import SwiftUI

struct NoteView: View {
    @Binding var note: Note
    @EnvironmentObject var model: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    private func didClcikDelete() {
        model.deleteNote(id: note.id)
        dismiss()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Title", text: $note.title)
                .font(.largeTitle)
                .padding(.bottom, 18)
            TextEditor(text: $note.body)
        }
        .padding()
        .toolbar {
            Button(action: didClcikDelete) {
                Image(systemName: "trash")
                    .foregroundStyle(Color.red)
            }
        }
        .navigationTitle("Intgelligent Notes")
    }
}

#Preview {
    NoteView(note: .constant(Note(title: "Title", body: "Body")))
}
