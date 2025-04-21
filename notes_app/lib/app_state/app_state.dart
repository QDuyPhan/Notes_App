import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/database/database_helper.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/notes.dart';
import 'package:notes_app/ultils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String userEmail = DEFAUL_EMAIL;
  late CollectionReference notesCollection;
  bool useSql = true;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  NotesModel notesModel = NotesModel();
  bool isDarkTheme = true;

  Future<void> initialization() async {
    await Firebase.initializeApp();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(THEME_KEY_SHAREDPRES) == null) {
      prefs.setBool(THEME_KEY_SHAREDPRES, isDarkTheme);
    } else {
      isDarkTheme = prefs.getBool(THEME_KEY_SHAREDPRES)!;
    }
    print('Dark Mode Preferences: ${prefs.getBool(THEME_KEY_SHAREDPRES)}');
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      userEmail = auth.currentUser!.email!;
      useSql = false;
    }
  }

  void setThemeBoolean(bool isUsingDarkTheme) async {
    this.isDarkTheme = isUsingDarkTheme;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_KEY_SHAREDPRES, isDarkTheme);
    notifyListeners();
  }

  void readNotes() {
    if (useSql) {
      _databaseHelper.initDatabase().then((value) => {readNotesFromDatabase()});
    } else {
      readNotesFromFirestore();
    }
  }

  void readNotesFromDatabase() async {
    notesModel = await _databaseHelper.gettAllNotes();
    print("All NOtes: $notesModel");
    notifyListeners();
  }

  void readNotesFromFirestore() {
    notesCollection = FirebaseFirestore.instance.collection(userEmail);
    notesCollection.get().then(
      (QuerySnapshot query) => {
        query.docs.forEach((element) {
          notesModel.saveNote(
            NoteModel(
              id: element.id,
              noteTitle: element[TITLE_DOCUMENT_FIELD],
              noteContent: element[CONTENT_DOCUMENT_FIELD],
              noteLabel: element[LABEL_DOCUMENT_FIELD],
            ),
          );
          notifyListeners();
        }),
      },
    );
  }

  void saveNote(NoteModel newNote, [int? index]) {
    this.notesModel.saveNote(newNote);
    if (index == null) {
      if (useSql) {
        _databaseHelper.insert(newNote);
      } else {
        notesCollection
            .doc(newNote.id)
            .set({
              TITLE_DOCUMENT_FIELD: newNote.noteTitle,
              CONTENT_DOCUMENT_FIELD: newNote.noteContent,
              LABEL_DOCUMENT_FIELD: newNote.noteLabel,
            })
            .then((value) => print("Note Added Successfully"))
            .catchError((error) => print("Failed to add note: $error"));
      }
    } else {
      if (useSql) {
        _databaseHelper.update(newNote);
      } else {
        notesCollection
            .doc(newNote.id)
            .update({
              TITLE_DOCUMENT_FIELD: newNote.noteTitle,
              CONTENT_DOCUMENT_FIELD: newNote.noteContent,
              LABEL_DOCUMENT_FIELD: newNote.noteLabel,
            })
            .then((value) => print("Note added in firestore"))
            .catchError(
              (error) =>
                  print("There was an error while updating note: $error"),
            );
      }
    }
    notifyListeners();
  }

  void deleteNote(NoteModel note) {
    this.notesModel.deleteNote(note: note);
    if (useSql) {
      _databaseHelper.delete(note);
    } else {
      notesCollection
          .doc(note.id)
          .delete()
          .then((value) => print("Note removed from firebase firestore"))
          .catchError(
            (error) =>
                print("There was an error while deleting the note: $error"),
          );
    }
    notifyListeners();
  }

  Future<STATUS> loginUser({String? email, String? password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      useSql = false;
      userEmail = email;

      migrateLocalDataToFirestore();
      notesModel = NotesModel();
      readNotes();
      return STATUS.successful;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return STATUS.weak_password;
      } else if (e.email == 'email-already-in-use') {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email!,
            password: password!,
          );
          userEmail = email;
          useSql = false;
          migrateLocalDataToFirestore();
          notesModel = NotesModel();
          readNotes();
          return STATUS.successful;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            return STATUS.wrong_password;
          } else {
            print("Some issue while logging in");
            return STATUS.unknownError;
          }
        }
      } else {
        print("Some issue while registration");
        return STATUS.unknownError;
      }
    }
  }

  void migrateLocalDataToFirestore() {
    notesCollection = FirebaseFirestore.instance.collection(userEmail);
    for (int i = 0; i < notesModel.notesCount; i++) {
      notesCollection
          .doc(notesModel.getNote(i).id)
          .set({
            TITLE_DOCUMENT_FIELD: notesModel.getNote(i).noteTitle,
            CONTENT_DOCUMENT_FIELD: notesModel.getNote(i).noteContent,
            LABEL_DOCUMENT_FIELD: notesModel.getNote(i).noteLabel,
          })
          .then((value) => print("Note added in firestore"))
          .catchError(
            (error) => print("There was an error while adding note: $error"),
          );
    }
    _databaseHelper.deleteNotesDatabase();
  }
}
