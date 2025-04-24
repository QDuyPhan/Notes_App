# 📒 Note App

A modern note-taking application built with Flutter. This app provides both offline and online note management capabilities, allowing users to create, edit, delete, and organize their notes efficiently across devices.
---

## 🚀 Features
📝 Create, Edit & Delete Notes
Quickly create new notes, update content or titles, and delete notes when no longer needed. Each note includes a title, content, and a label with customizable color.

☁️ **Cloud Sync with Firebase**
- Automatically sync your notes with Firebase Firestore, enabling cross-device access and backup in real-time.

📦 **Offline Storage**
- Powered by sqflite, your notes are stored locally for offline access and persistence, even after restarting the app.

🔍 **Smart Search**
- Find notes instantly by searching their titles or contents using a floating search bar.

🎨 **Theme Switcher**
- Toggle between light and dark themes. Preferences are saved using shared_preferences and persist across sessions.

🔐 **User Authentication**
- Sign Up: Register new accounts with email and password.
- Login: Secure login for existing users to access their synced notes.
- Logout: Safely log out to protect your data.

## 🛠️ Tech Stack
- **Flutter & Dart** – Main framework and language for cross-platform development
- **Provider** – Lightweight state management solution for managing app state 
- **Sqflite** – Local SQLite database for storing notes offline
- **Shared Preferences** – Persistent key-value storage for user settings
- **Firebase** – Cloud services integration for:
  - 🔐 **Firebase Auth** – User authentication (sign up, login, logout)
  - ☁️ **Cloud Firestore** – Realtime database for syncing notes online
---

## 📦 Installation

```bash
git clone https://github.com/QDuyPhan/Notes_App.git
```

## 📄 License

This project is licensed under the [`MIT License`](LICENSE).

```text
MIT License
Copyright (c) 2025 Phan Quang Duy
```