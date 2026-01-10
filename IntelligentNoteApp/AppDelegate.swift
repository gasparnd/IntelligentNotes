//
//  AppDelegate.swift
//  IntelligentNoteApp
//
//  Created by Gaspar Dolcemascolo on 09-01-26.
//

import AppKit
import Carbon

class AppDelegate: NSObject, NSApplicationDelegate {

    var hotKeyRef: EventHotKeyRef?

    func applicationDidFinishLaunching(_ notification: Notification) {
        registerHotKey()
    }

    func registerHotKey() {
        print("⌨️ Registering hotkey")

        let keyCode = UInt32(kVK_Space)
        let modifiers = UInt32(shiftKey | optionKey)

        let hotKeyID = EventHotKeyID(
            signature: OSType(0x514E5445), // "QNTE"
            id: 1
        )

        let status = RegisterEventHotKey(
            keyCode,
            modifiers,
            hotKeyID,
            GetEventDispatcherTarget(),
            0,
            &hotKeyRef
        )

        print("RegisterEventHotKey status:", status)

        installHotKeyHandler()
    }


    func installHotKeyHandler() {
        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )

        InstallEventHandler(
            GetEventDispatcherTarget(), // 🔑 KEY
            { (_, eventRef, _) -> OSStatus in
                var hotKeyID = EventHotKeyID()

                GetEventParameter(
                    eventRef,
                    EventParamName(kEventParamDirectObject),
                    EventParamType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &hotKeyID
                )

                if hotKeyID.id == 1 {
                    DispatchQueue.main.async {
                        HotKeyManager.shared.trigger()
                    }
                }
                return noErr
            },
            1,
            &eventType,
            nil,
            nil
        )
    }
}
