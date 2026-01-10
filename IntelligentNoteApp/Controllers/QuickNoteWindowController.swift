//
//  QuickNoteWindowController.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 10-01-26.
//

import AppKit
import SwiftUI

final class QuickNoteWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}


final class QuickNoteWindowController {
    static let shared = QuickNoteWindowController()
    private var window: NSWindow?

    func toggle() {
        if window != nil {
            close()
        } else {
            open()
        }
    }
    
    func open() {
        let view = QuickNoteView { text in
            let note = Note(
                title: "Quick Note",
                body: text
            )
            NotesService.shared.createNote(from: note)
            self.close()
        }

        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = NSRect(x: 0, y: 0, width: 600, height: 90)

        let window = QuickNoteWindow(
            contentRect: hostingView.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        window.contentView = hostingView
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.hasShadow = true
        window.center()
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        self.window = window
    }

    func close() {
        window?.orderOut(nil)
        window = nil
    }
}

