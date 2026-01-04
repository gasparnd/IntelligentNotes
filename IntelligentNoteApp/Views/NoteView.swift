//
//  NoteView.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 02-01-26.
//

import SwiftUI
internal import Combine

struct NoteView: View {
    @Binding var note: Note
    @EnvironmentObject var model: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    // Timer that executes every 10 seconds
    private let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    // State to track previous text and avoid multiple executions
    @State private var previousBodyText: String = ""
    
    private func didClcikDelete() {
        model.deleteNote(id: note.id)
        dismiss()
    }
    
    private func updateNote() {
        var newNote = note
        newNote.title = note.title
        newNote.body = note.body
        model.updateNote(id: note.id, with: newNote)
    }
    
    private func handleThinkCommand(instruction: String) {
        print("Think command received with instruction: \(instruction)")
        // Add the logic you need to execute here
    }
    
    private func checkForThinkCommand(in newText: String, oldText: String) {
        let pattern = "/think: "
        
        // Find the last occurrence of "/think: " in the new text
        guard let lastRange = newText.range(of: pattern, options: .backwards) else {
            return
        }
        
        let instructionStart = lastRange.upperBound
        
        // Find the end of the instruction (newline, end of text, or two consecutive spaces)
        var instructionEnd = instructionStart
        var foundDoubleSpace = false
        
        // Search until finding newline, end of text, or two consecutive spaces
        while instructionEnd < newText.endIndex {
            let char = newText[instructionEnd]
            
            // If we find two consecutive spaces, the instruction is not valid
            if char == " " && instructionEnd < newText.index(before: newText.endIndex) {
                let nextIndex = newText.index(after: instructionEnd)
                if nextIndex < newText.endIndex && newText[nextIndex] == " " {
                    foundDoubleSpace = true
                    break
                }
            }
            
            // If we find a newline, we end the instruction
            if char == "\n" {
                break
            }
            
            instructionEnd = newText.index(after: instructionEnd)
        }
        
        // Extract the instruction
        let instruction = String(newText[instructionStart..<instructionEnd]).trimmingCharacters(in: .whitespaces)
        
        // Only execute if:
        // 1. There are no two consecutive spaces
        // 2. There is a non-empty instruction
        // 3. This is a new occurrence (it wasn't in the previous text)
        if !foundDoubleSpace && !instruction.isEmpty {
            // Check if this instruction is new by comparing with the previous text
            let previousInstruction: String
            if let prevRange = oldText.range(of: pattern, options: .backwards),
               prevRange.upperBound < oldText.endIndex {
                let prevStart = prevRange.upperBound
                var prevEnd = prevStart
                while prevEnd < oldText.endIndex && oldText[prevEnd] != "\n" {
                    prevEnd = oldText.index(after: prevEnd)
                }
                previousInstruction = String(oldText[prevStart..<prevEnd]).trimmingCharacters(in: .whitespaces)
            } else {
                previousInstruction = ""
            }
            
            // Only execute if the instruction is different from the previous one
            if instruction != previousInstruction {
                handleThinkCommand(instruction: instruction)
            }
        }
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
        .onReceive(timer) { _ in
            updateNote()
        }
        .onChange(of: note.body) { oldValue, newValue in
            // Verify if text contains Think command
            if newValue.contains("/think: ") {
                checkForThinkCommand(in: newValue, oldText: oldValue)
            }
            previousBodyText = newValue
        }
        .onAppear {
            previousBodyText = note.body
        }
    }
}

#Preview {
    NoteView(note: .constant(Note(title: "Title", body: "Body")))
}
