import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/notes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../ultils/constants.dart';

class DatabaseHelper {
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  late Database _database;

  Future<void> initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, DATABASE_NAME);
    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $TABLE_NOTE (
        $COLUMN_ID STRING PRIMARY KEY,
        $COLUMN_TITLE TEXT,
        $COLUMN_CONTENT TEXT NOT NULL,
        $COLUMN_LABEL INTEGER NOT NULL
      )''');
      },
    );
  }

  Future<NotesModel> getAllNotes() async {
    final db = await _database;
    List<Map<String, dynamic>> maps = await db.query(TABLE_NOTE);
    NotesModel notes = NotesModel();

    // Sửa lỗi cú pháp forEach và ép kiểu
    for (var element in maps) {
      notes.saveNote(
        NoteModel(
          id: element[COLUMN_ID].toString(), // Đảm bảo id là String
          noteTitle: element[COLUMN_TITLE]?.toString() ?? "",
          noteContent: element[COLUMN_CONTENT]?.toString() ?? "",
          noteLabel: element[COLUMN_LABEL] as int, // noteLabel là int
        ),
      );
    }

    print('Notes in database: $maps');
    return notes;
  }

  Future<void> insert(NoteModel note) async {
    await _database.insert(TABLE_NOTE, note.toMap());
  }

  Future<void> update(NoteModel note) async {
    await _database.update(
      TABLE_NOTE,
      note.toMap(),
      where: '$COLUMN_ID = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> delete(NoteModel note) async {
    await _database.delete(
      TABLE_NOTE,
      where: '$COLUMN_ID = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNotesDatabase() async {
    // Remove the database and all the entries
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DATABASE_NAME);

    await deleteDatabase(path);
  }
}
