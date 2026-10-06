# Xcode AI to Text

Save complete Xcode Coding Intelligence answers as Markdown instead of manually copying fragments and code snippets.

Xcode AI to Text is a small macOS menu-bar utility paired with an Xcode Source Editor Extension. It is intentionally local and simple: no API keys, no AI service, and no cloud account.

## What it does

- Capture a complete, visible Xcode AI answer through macOS Accessibility when available.
- Preserve the answer as Markdown, including headings, lists, tables, and fenced code blocks.
- Copy the complete Markdown answer to the clipboard so it is ready to paste anywhere.
- Save answers to `~/Documents/Xcode AI Answers/`.
- Fall back to the clipboard when Accessibility cannot read the current AI response.
- Add an Xcode Editor command: **Editor → Xcode AI Answer Saver → Save Clipboard as Markdown**.
- Generate a readable filename from the first Markdown heading or the beginning of the answer.

## Why two pieces?

Apple's public XcodeKit Source Editor Extension API works with the source editor, but it does not expose the private Coding Intelligence conversation transcript directly. The companion macOS app therefore handles the live capture using the public macOS Accessibility API. The Xcode extension remains a small, reliable clipboard-to-Markdown fallback.

This avoids private Xcode APIs and keeps the project maintainable when Xcode changes its internal AI UI.

## Requirements

- macOS 14 or newer
- Xcode 15 or newer
- An Xcode installation with Coding Intelligence enabled

## Installation

### 1. Open the project

The repository includes `project.yml`. Generate the Xcode project with XcodeGen:

```bash
brew install xcodegen
cd Xcode-AI-to-Text
xcodegen generate
open XcodeAIAnswerSaver.xcodeproj
```

If you do not use XcodeGen, follow [PROJECT_SETUP.md](PROJECT_SETUP.md).

### 2. Build the macOS app

In Xcode, select the **XcodeAIAnswerSaver** macOS app target and Build & Run it once.

The app runs as a menu-bar utility and does not need a normal Dock window.

### 3. Grant Accessibility permission

Go to:

**System Settings → Privacy & Security → Accessibility**

Enable **Xcode AI Answer Saver**.

This permission is used only for reading the visible Xcode accessibility tree so the utility can recover the complete AI answer.

### 4. Save an answer

Open an Xcode Coding Intelligence conversation, bring the desired answer into view, and press:

**⌥⌘S**

The utility saves a Markdown file in:

```text
~/Documents/Xcode AI Answers/
```

The same complete Markdown is also placed on the clipboard, ready to paste.

### 5. Enable the Xcode Source Editor Extension

Open:

**System Settings → General → Login Items & Extensions → Xcode Source Editor**

Enable **Xcode AI Answer Saver**.

Restart Xcode if necessary.

The fallback command is available from:

**Editor → Xcode AI Answer Saver → Save Clipboard as Markdown**

## Clipboard fallback

When Accessibility cannot extract the AI response, copy the full answer in Xcode and invoke **Save Xcode AI Answer** again from the menu-bar app, or use the Xcode Source Editor command.

## Development

Project generation is described in [PROJECT_SETUP.md](PROJECT_SETUP.md). The Markdown formatter has unit tests in `XcodeAIAnswerSaverTests`.

The project uses only Apple frameworks:

- AppKit
- ApplicationServices
- XcodeKit
- XCTest

## Privacy

Answers are saved locally to your Mac. The project does not send chat content to an external service.

## Status

Early utility for personal development workflows. The source-editor extension is intentionally kept small, while the macOS companion handles Xcode AI capture through Accessibility.

## License

MIT License. See [LICENSE](LICENSE).
