# Xcode AI to Text

Save complete Xcode Coding Intelligence answers as Markdown instead of manually copying fragments and code snippets.

Xcode AI to Text is a small local macOS menu-bar utility paired with an Xcode Source Editor Extension. It is designed around one workflow: capture the complete AI answer, save it as `Markdown`, and keep the full answer on the clipboard for immediate copy/paste.

## What it does

- Capture the complete visible Xcode AI answer through macOS Accessibility.
- Preserve Markdown structure, including headings, lists, tables, and fenced code blocks.
- Copy the complete answer to the clipboard after saving.
- Save answers to `~/Documents/Xcode AI Answers/`.
- Provide an Xcode Editor fallback command to save clipboard content as Markdown.
- Use predictable filenames based on the answer title.
- Stay entirely local. No API keys, AI APIs, or cloud services.

## Requirements

- macOS 14+
- Xcode 15+
- XcodeGen 2.46+ (recommended for project generation)
- Xcode Coding Intelligence enabled

## Installation

Clone the repository:

```bash
git clone https://github.com/Gabirell/Xcode-AI-to-Text.git
cd Xcode-AI-to-Text
```

Generate the Xcode project:

```bash
xcodegen generate
open XcodeAIAnswerSaver.xcodeproj
```

In Xcode, select **XcodeAIAnswerSaver** with **My Mac** as the destination and build/run with **⌘R**.

Then enable Accessibility:

**System Settings → Privacy & Security → Accessibility**

Add or enable **Xcode AI Answer Saver**.

## Using it

Keep the utility running in the menu bar as **AI Saver**.

With the desired Xcode AI answer visible, press:

**⌥⌘S**

The app will:

1. Read the visible answer.
2. Save the complete Markdown to `~/Documents/Xcode AI Answers/`.
3. Put that same complete Markdown on the clipboard.

That means you can immediately paste the answer into another chat, a README, a note, a documentation file, GitHub, or anywhere else that accepts text.

## Xcode extension fallback

The source editor extension adds:

**Editor → Xcode AI Answer Saver → Save Clipboard as Markdown**

Use this when the full answer has already been copied to the clipboard but Accessibility capture is unavailable.

## Why the companion app?

XcodeKit's public Source Editor Extension API does not expose Xcode's private Coding Intelligence conversation transcript directly. The companion macOS app therefore uses the public macOS Accessibility framework to read the visible Xcode UI, while the extension remains a small clipboard-to-Markdown fallback.

No private Xcode APIs are required.

## Project structure

```text
Xcode-AI-to-Text/
├── XcodeAIAnswerSaver/
│   ├── AppDelegate.swift
│   ├── AccessibilityCapture.swift
│   ├── AnswerSaver.swift
│   ├── MarkdownFormatter.swift
│   └── Info.plist
├── XcodeAIAnswerSaverExtension/
│   ├── SourceEditorExtension.swift
│   ├── SourceEditorCommand.swift
│   ├── MarkdownFormatter.swift
│   └── Info.plist
├── XcodeAIAnswerSaverTests/
├── project.yml
├── PROJECT_SETUP.md
├── README.md
└── LICENSE
```

## Privacy

All captured answers are saved locally on your Mac. The application does not upload conversation content anywhere.

## Status

Early personal-development utility. The capture mechanism depends on the accessibility hierarchy exposed by the current Xcode UI, so future Xcode releases may require compatibility updates.

## License

MIT
