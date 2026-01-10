//
//  QuickNoteView.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 10-01-26.
//

import SwiftUI

struct QuickNoteView: View {
    @State private var text: String = ""
    @FocusState private var focused: Bool

    let onSubmit: (String) -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "bolt.fill")
                .foregroundStyle(.secondary)
                .font(.system(size: 18))

            TextField("Write a quick note…", text: $text)
                .font(.system(size: 22, weight: .medium))
                .textFieldStyle(.plain)
                .focused($focused)
                .onSubmit {
                    guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    onSubmit(text)
                }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .onAppear {
            focused = true
        }
        .onExitCommand {
            QuickNoteWindowController.shared.close()
        }
    }
}

//#Preview {
//    QuickNoteView()
//}
