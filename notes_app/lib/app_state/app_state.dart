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
    if (useSql) {
      print("Offline");
    } else {
      print("Online");
    }
  }

  void setThemeBoolean(bool isUsingDarkTheme) async {
    isDarkTheme = isUsingDarkTheme;
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

  Future<void> readNotesFromDatabase() async {
    try {
      notesModel = await _databaseHelper.getAllNotes();
      print("All Notes: $notesModel");
      notifyListeners();
    } catch (e) {
      print("Error reading notes from database: $e");
    }
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
    notesModel.saveNote(newNote, index);
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
    notesModel.deleteNote(note: note);
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



  Future<void> migrateLocalDataToFirestore() async {
    try {
      // Đọc dữ liệu từ SQLite trước
      await readNotesFromDatabase();

      // Kiểm tra nếu có dữ liệu để đồng bộ
      if (notesModel.notesCount == 0) {
        print("No notes to migrate to Firestore.");
        return;
      }

      notesCollection = FirebaseFirestore.instance.collection(userEmail);
      List<Future> uploadTasks = [];

      // Tạo danh sách các tác vụ tải lên Firestore
      for (int i = 0; i < notesModel.notesCount; i++) {
        final note = notesModel.getNote(i);
        uploadTasks.add(
          notesCollection.doc(note.id).set({
            TITLE_DOCUMENT_FIELD: note.noteTitle,
            CONTENT_DOCUMENT_FIELD: note.noteContent,
            LABEL_DOCUMENT_FIELD: note.noteLabel,
          }).then((value) {
            print("Note $i added to Firestore: ${note.noteTitle}");
          }).catchError((error) {
            print("Error adding note $i to Firestore: $error");
          }),
        );
      }

      // Chờ tất cả các tác vụ tải lên hoàn tất
      await Future.wait(uploadTasks);

      // Xóa cơ sở dữ liệu SQLite sau khi đồng bộ
      await _databaseHelper.deleteNotesDatabase();
      print("Local SQLite database deleted after migration.");
    } catch (e) {
      print("Error during migration to Firestore: $e");
    }
  }

  // Hàm đăng ký người dùng
  Future<STATUS> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      userEmail = email;
      useSql = false;
      await migrateLocalDataToFirestore();
      notesModel = NotesModel();
      readNotes();
      notifyListeners();
      return STATUS.successful;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return STATUS.weak_password;
      } else if (e.code == 'email-already-in-use') {
        return STATUS.email_already_in_use;
      } else {
        print("Error during registration: $e");
        return STATUS.unknownError;
      }
    } catch (e) {
      print("Unexpected error during registration: $e");
      return STATUS.unknownError;
    }
  }

  // Hàm đăng nhập người dùng
  Future<STATUS> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      userEmail = email;
      useSql = false;
      await migrateLocalDataToFirestore();
      notesModel = NotesModel();
      readNotes();
      notifyListeners();
      return STATUS.successful;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return STATUS.wrong_password;
      } else if (e.code == 'user-not-found') {
        return STATUS.user_not_found;
      } else {
        print("Error during login: $e");
        return STATUS.unknownError;
      }
    } catch (e) {
      print("Unexpected error during login: $e");
      return STATUS.unknownError;
    }
  }

  // Hàm đăng xuất người dùng
  Future<STATUS> logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      userEmail = DEFAUL_EMAIL;
      useSql = true;
      notesModel = NotesModel();
      readNotes();
      notifyListeners();
      return STATUS.successful;
    } catch (e) {
      print("Error during logout: $e");
      return STATUS.unknownError;
    }
  }
}
