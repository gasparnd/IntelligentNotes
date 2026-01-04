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
    
    private func handleThinkCommand(instruction: String, commandRange: Range<String.Index>, fullText: String) {
        print("Think command received with instruction: \(instruction)")
        
        // Save the command text to search for it later (since the text might change)
        let commandText = String(fullText[commandRange])
        
        // Create a Task that waits 5 seconds and then replaces the command
        Task {
            try? await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
            
            await MainActor.run {
                // Find the command in the current text and replace it
                if let range = note.body.range(of: commandText) {
                    let replacement = "This is the result of the think: command!"
                    note.body.replaceSubrange(range, with: replacement)
                }
            }
        }
    }
    
    private func checkForThinkCommand(in newText: String, oldText: String) {
        let pattern = "/think: "
        
        // Find the last occurrence of "/think: " in the new text
        guard let lastRange = newText.range(of: pattern, options: .backwards) else {
            return
        }
        
        let instructionStart = lastRange.upperBound
        
        // Check if there's content after the colon and space
        guard instructionStart < newText.endIndex else {
            return
        }
        
        // Find the end of the instruction by looking for two consecutive spaces
        var instructionEnd = instructionStart
        var foundDoubleSpace = false
        var hasContent = false
        
        // Search until finding newline, end of text, or two consecutive spaces
        while instructionEnd < newText.endIndex {
            let char = newText[instructionEnd]
            
            // Track if we have content (non-space characters)
            if char != " " && char != "\n" {
                hasContent = true
            }
            
            // If we find two consecutive spaces, the command has finished
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
        
        // The command is complete when:
        // 1. We found two consecutive spaces
        // 2. There is content after "/think: "
        // 3. This is a new occurrence (it wasn't in the previous text)
        if foundDoubleSpace && hasContent {
            // Extract the instruction (up to the first space of the double space)
            let instruction = String(newText[instructionStart..<instructionEnd]).trimmingCharacters(in: .whitespaces)
            
            // Check if this command is new by comparing with the previous text
            let previousCommandText: String
            if let prevRange = oldText.range(of: pattern, options: .backwards),
               prevRange.upperBound < oldText.endIndex {
                let prevStart = prevRange.upperBound
                var prevEnd = prevStart
                var prevFoundDoubleSpace = false
                
                while prevEnd < oldText.endIndex && oldText[prevEnd] != "\n" {
                    if oldText[prevEnd] == " " && prevEnd < oldText.index(before: oldText.endIndex) {
                        let nextIndex = oldText.index(after: prevEnd)
                        if nextIndex < oldText.endIndex && oldText[nextIndex] == " " {
                            prevFoundDoubleSpace = true
                            break
                        }
                    }
                    prevEnd = oldText.index(after: prevEnd)
                }
                
                if prevFoundDoubleSpace {
                    previousCommandText = String(oldText[prevRange.lowerBound..<prevEnd])
                } else {
                    previousCommandText = ""
                }
            } else {
                previousCommandText = ""
            }
            
            // Create the full command range (from "/think: " to the first space of the double space)
            let commandRange = lastRange.lowerBound..<instructionEnd
            
            // Only execute if this is a new command (it wasn't in the previous text)
            let currentCommandText = String(newText[commandRange])
            if currentCommandText != previousCommandText {
                handleThinkCommand(instruction: instruction, commandRange: commandRange, fullText: newText)
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
