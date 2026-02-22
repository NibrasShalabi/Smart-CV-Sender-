# Smart CV 🚀

An intelligent Flutter application that automates job application emails
using Google's Gemini AI and Gmail API.

## Features
- 🤖 AI-generated cover letters tailored to each company
- 📧 One-tap email sending with CV attachment via Gmail API
- 💾 Local profile storage with SQLite
- 📋 Application history tracking
- 🔐 Secure OAuth 2.0 authentication

## Tech Stack
- **Framework:** Flutter
- **Architecture:** Clean Architecture + Bloc
- **AI:** Google Gemini 2.5 Flash
- **Email:** Gmail API via OAuth 2.0
- **Database:** SQLite (sqflite)
- **State Management:** flutter_bloc

## Setup
1. Clone the repository
2. Run `flutter pub get`
3. Add your Gemini API key in Run Configurations:
   `--dart-define=GEMINI_API_KEY=YOUR_KEY_HERE`
4. Configure Gmail OAuth in Google Cloud Console
5. Run `flutter run`

## Architecture
```
lib/
├── core/         # Services & Database
└── features/
    ├── profile/  # User profile management
    ├── compose/  # Email composition & AI generation
    └── history/  # Application tracking
```

## Author
Nibras Shalabi — Flutter Developer