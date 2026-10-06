# Project setup

## Recommended: XcodeGen

The repository includes `project.yml`.

Install XcodeGen with Homebrew if needed:

```bash
brew install xcodegen
```

Generate the project:

```bash
cd Xcode-AI-to-Text
xcodegen generate
open XcodeAIAnswerSaver.xcodeproj
```

The project defines:

- `XcodeAIAnswerSaver`: macOS menu-bar application
- `XcodeAIAnswerSaverExtension`: Xcode Source Editor Extension
- `XcodeAIAnswerSaverTests`: unit tests

## Manual setup

If you do not use XcodeGen, create a macOS App target named `XcodeAIAnswerSaver` and an Xcode Source Editor Extension target named `XcodeAIAnswerSaverExtension`.

Add the corresponding Swift files from this repository to each target. The app target needs **AppKit** and **ApplicationServices**. The extension target needs **XcodeKit** and **AppKit**.

The extension Info.plist must declare the Xcode source-editor extension point:

```xml
<key>NSExtension</key>
<dict>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.dt.Xcode.extension.source-editor</string>
    <key>NSExtensionPrincipalClass</key>
    <string>$(PRODUCT_MODULE_NAME).SourceEditorExtension</string>
</dict>
```

The app is configured as a menu-bar utility with `LSUIElement = YES`.

## First run

Build and run the macOS application once, then grant Accessibility permission under:

**System Settings → Privacy & Security → Accessibility**

Enable **Xcode AI Answer Saver**.
