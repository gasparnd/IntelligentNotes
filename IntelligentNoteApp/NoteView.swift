//
//  NoteView.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 02-01-26.
//

import SwiftUI

struct NoteView: View {
    @Binding var note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Title", text: $note.title)
                .font(.largeTitle)
                .padding(.bottom, 18)
            TextEditor(text: $note.body)
        }.padding().navigationTitle("Intgelligent Notes")
    }
}

#Preview {
    NoteView(note: .constant(Note(title: "Title", body: "Body")))
}
