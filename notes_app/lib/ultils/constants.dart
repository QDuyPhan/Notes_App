import 'package:flutter/material.dart';

const SURFACE_COLOR_DARK = Color(0xFF1F1F1F);
const BLUE_COLOR = Color(0xFF007EA7);

const DARK_THEME_COLOR = Color(0xFF2E2E2E);
const LIGHT_THEME_COLOR = Color(0xFFFAFAFA);
const NOTE_BACKGROUND_COLOR = Color(0xFF353535);

const BUTTON_COLOR = Color(0xFF5C49E0);

const TEXT_COLOR = Color(0xFF817F80);
const DARK_THEME_WHITE_GREY = Colors.white60;

const ICON_SIZE = 30.0;

const NOTE_STYLE = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
  letterSpacing: 1.1,
);

const Map<int, Color> LABEL_COLOR = {
  0: Colors.lightBlueAccent,
  1: Colors.redAccent,
  2: Colors.purpleAccent,
  3: Colors.greenAccent,
  4: Colors.yellowAccent,
  5: Colors.blueAccent,
  6: Colors.orangeAccent,
  7: Colors.pinkAccent,
  8: Colors.tealAccent,
};

// Firebase
final String DEFAUL_EMAIL = 'email@gmail.com';
final String TITLE_DOCUMENT_FIELD = 'title';
final String CONTENT_DOCUMENT_FIELD = 'content';
final String LABEL_DOCUMENT_FIELD = 'label';

// Shared Preferences
final String EMAIL_KEY_SHAREDPRES = 'userEmail';
final String THEME_KEY_SHAREDPRES = 'appTheme';

// SQLite Database
final String DATABASE_NAME = 'notesDatabase.db';
final String TABLE_NOTE = "notes";
final String COLUMN_ID = "id";
final String COLUMN_TITLE = 'title';
final String COLUMN_CONTENT = 'content';
final String COLUMN_LABEL = 'label';

const INPUT_FIELD_DECORATION = InputDecoration(
  labelText: "Email",
  // errorText: "Some error occurred",
  errorStyle: TextStyle(fontSize: 14, color: Colors.red),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.redAccent),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: BLUE_COLOR),
    gapPadding: 4,
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.redAccent),
  ),
);

const TEXT_STYLE = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w800,
  letterSpacing: 1.1,
);

enum STATUS {
  wrong_password,
  weak_password,
  successful,
  unknownError,
  email_already_in_use,
  user_not_found,
}
