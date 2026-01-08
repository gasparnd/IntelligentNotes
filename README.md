# Intelligent Note App

An intelligent iOS note-taking application that integrates with Apple's FoundationModels to provide AI-powered assistance directly within your notes.

## Features

- 📝 Create, edit, and delete notes
- 💾 Automatic persistence using SwiftData
- 🤖 AI-powered commands using `/think:` syntax
- ⏱️ Auto-save every 10 seconds
- 📥 Export notes to text files
- 🎨 Clean SwiftUI interface

## Requirements

- **Xcode 15.0+** (or latest version)
- **iOS 18.0+** (for FoundationModels support)
- **macOS 15.0+** (for development)
- **Apple Intelligence enabled device** (for AI features)

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd IntelligentNoteApp
```

### 2. Open in Xcode

1. Open `IntelligentNoteApp.xcodeproj` in Xcode
2. Wait for Xcode to resolve dependencies and index the project

### 3. Configure Signing

1. Select the project in the navigator
2. Go to the "Signing & Capabilities" tab
3. Select your development team
4. Xcode will automatically manage provisioning profiles

### 4. Select a Target Device

- Choose a physical device running iOS 18.0+ (recommended for AI features)
- Or use the iOS Simulator (AI features may be limited)

### 5. Build and Run

1. Press `⌘ + R` or click the "Run" button
2. The app will build and launch on your selected device/simulator

## Running the App

### First Launch

1. The app will display a welcome note
2. Tap the "+" button in the toolbar to create a new note
3. Start writing your notes!

### Using the `/think:` Command

The app features a special command syntax that allows you to interact with AI:

1. Type `/think: ` followed by your question or instruction
2. Add **two consecutive spaces** (`  `) to execute the command
3. The command will be replaced with "Thinking..." while processing
4. After processing, it will be replaced with the AI's response

**Example:**
```
/think: Summarize this note  
```

The AI will analyze your note and provide a summary.

### Note Management

- **Create**: Tap the "+" button in the toolbar
- **Edit**: Select a note from the list and start typing
- **Delete**: Tap the trash icon in the note view toolbar
- **Export**: Tap the download icon to save the note as a `.txt` file

## Code Structure Guide

Understanding the codebase architecture will help you navigate and contribute effectively.

### Architecture Overview

The app follows the **MVVM (Model-View-ViewModel)** pattern with protocol-oriented design:

```
┌─────────────┐
│    Views    │  (SwiftUI)
└──────┬──────┘
       │
┌──────▼──────────┐
│  ViewModels     │  (Business Logic)
└──────┬──────────┘
       │
┌──────▼──────────┐
│  Data Sources   │  (Data Layer)
└──────┬──────────┘
       │
┌──────▼──────────┐
│    Models       │  (SwiftData)
└─────────────────┘
```

### Where to Start

#### 1. **Entry Point** - `IntelligentNoteApp.swift`
   - **Location**: `IntelligentNoteApp/IntelligentNoteApp.swift`
   - **Purpose**: App initialization and dependency injection
   - **Key Concepts**:
     - Sets up SwiftData `ModelContainer`
     - Creates `LocalDataSource` with SwiftData context
     - Initializes `NotesViewModel` with the data source
     - Injects view model as environment object

   **Start here** to understand how the app initializes and how dependencies flow.

#### 2. **Data Models** - `Models/NoteModel.swift`
   - **Location**: `IntelligentNoteApp/Models/NoteModel.swift`
   - **Purpose**: Defines the core data structures
   - **Key Components**:
     - `Note`: Swift struct used throughout the app (Identifiable, Hashable)
     - `NoteModel`: SwiftData `@Model` class for persistence
     - `toNote()`: Converts SwiftData model to app model

   **Understanding this** helps you see how data is structured and persisted.

#### 3. **Protocols** - `Contracts/`
   - **Location**: `IntelligentNoteApp/Contracts/`
   - **Files**:
     - `DataSourceProtocol.swift`: Defines data operations interface
     - `ViewModelProtocol.swift`: Defines view model interface
   - **Purpose**: Protocol-oriented design for testability and flexibility

   **These protocols** define the contracts that components must follow.

#### 4. **Data Layer** - `LocalDataSource.swift`
   - **Location**: `IntelligentNoteApp/LocalDataSource.swift`
   - **Purpose**: Implements `DataSourceProtocol` using SwiftData
   - **Key Operations**:
     - `getNotes()`: Fetches all notes sorted by creation date
     - `createNote(from:)`: Saves a new note
     - `updateNote(id:with:)`: Updates an existing note
     - `deleteNote(id:)`: Removes a note

   **This is where** all database operations happen.

#### 5. **Business Logic** - `ViewModels/NotesViewModel.swift`
   - **Location**: `IntelligentNoteApp/ViewModels/NotesViewModel.swift`
   - **Purpose**: Manages app state and business logic
   - **Key Features**:
     - `@Published var notes`: Observable array of notes
     - CRUD operations that coordinate between views and data source
     - `analyzeWith(command:noteBody:)`: AI integration using FoundationModels
     - `downloadNote(id:)`: Exports notes to files

   **This is the heart** of the app's business logic.

#### 6. **Main View** - `Views/ContentView.swift`
   - **Location**: `IntelligentNoteApp/Views/ContentView.swift`
   - **Purpose**: Main navigation and note list
   - **Key Features**:
     - `NavigationSplitView`: Master-detail interface
     - List of notes with selection
     - Toolbar button to create new notes
     - Passes selected note to `NoteView`

   **This is the main UI** you see when the app launches.

#### 7. **Note Editor** - `Views/NoteView.swift`
   - **Location**: `IntelligentNoteApp/Views/NoteView.swift`
   - **Purpose**: Individual note editing interface
   - **Key Features**:
     - Text field for title
     - Text editor for body
     - Auto-save timer (every 10 seconds)
     - `/think:` command detection and processing
     - Delete and export buttons

   **This is where** the magic happens - note editing and AI commands.

### Key Code Patterns

#### Command Detection Pattern

The `/think:` command detection in `NoteView.swift` is a good example of text parsing:

```swift
checkForThinkCommand(in:newText:oldText:)
```

This function:
1. Searches for `/think: ` pattern
2. Detects when command completes (two consecutive spaces)
3. Extracts the instruction
4. Prevents duplicate executions
5. Calls `handleThinkCommand()` to process

#### AI Integration Pattern

The AI integration in `NotesViewModel.swift`:

```swift
func analyzeWith(command:noteBody:) async throws -> String
```

This function:
1. Checks system language model availability
2. Creates a `LanguageModelSession`
3. Builds a prompt with note context
4. Sends request and returns response

#### Auto-Save Pattern

The auto-save uses a `Timer` publisher:

```swift
private let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
```

This automatically saves notes every 10 seconds without user intervention.

### File Organization

```
IntelligentNoteApp/
├── IntelligentNoteApp.swift      # App entry point
├── Contracts/                     # Protocol definitions
│   ├── DataSourceProtocol.swift
│   └── ViewModelProtocol.swift
├── Models/                        # Data models
│   └── NoteModel.swift
├── ViewModels/                    # Business logic
│   └── NotesViewModel.swift
├── LocalDataSource.swift          # Data persistence
└── Views/                         # UI components
    ├── ContentView.swift          # Main view
    └── NoteView.swift             # Note editor
```

### Dependencies

- **SwiftUI**: UI framework
- **SwiftData**: Data persistence
- **FoundationModels**: AI language model integration
- **Combine**: Reactive programming (internal import)

### Common Tasks

#### Adding a New Feature

1. Define data model changes in `Models/NoteModel.swift`
2. Update `DataSourceProtocol` if new data operations needed
3. Implement in `LocalDataSource`
4. Update `ViewModelProtocol` if new business logic needed
5. Implement in `NotesViewModel`
6. Update UI in appropriate view file

#### Debugging

- Check console for error messages (prefixed with ❌ or ✅)
- AI errors are caught and displayed in the note
- SwiftData errors are logged to console

#### Testing AI Features

1. Ensure device has Apple Intelligence enabled
2. Check `checkForSystemLanguageModelAvailability()` return value
3. Test with simple commands first: `/think: Hello  `

## Troubleshooting

### AI Features Not Working

- **Issue**: "Apple Intelligence is not enabled"
- **Solution**: Enable Apple Intelligence in Settings > Siri & Search

- **Issue**: "Device not eligible"
- **Solution**: AI features require compatible hardware (iPhone 15 Pro or newer, M1+ Mac)

### Build Errors

- **Issue**: "Cannot find FoundationModels"
- **Solution**: Ensure you're using Xcode 15+ and iOS 18+ SDK

- **Issue**: SwiftData errors
- **Solution**: Clean build folder (⌘ + Shift + K) and rebuild

### Data Not Persisting

- Check console for SwiftData error messages
- Verify ModelContainer initialization in `IntelligentNoteApp.swift`
- Ensure proper SwiftData model configuration

## Contributing

When contributing:

1. Follow the existing architecture patterns
2. Update protocols when adding new features
3. Keep views focused on presentation
4. Put business logic in ViewModels
5. Use SwiftData for persistencex

## Author

Created by Gaspar Dolcemascolo

