import 'package:notes_sqflite_bloc/database/db_helper.dart';
import 'package:notes_sqflite_bloc/model/notes.dart';

class NotesDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createNotes(Notes notes) async {
    final db = await dbProvider.database;
    var result = db.insert(notesTABLE, notes.toDatabaseJson());
    return result;
  }

  Future<List<Notes>> getNotes({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null && query != '') {
      if (query.isNotEmpty)
        result = await db.query(notesTABLE,
            columns: columns, where: 'title LIKE ?', whereArgs: ["%$query%"]);
    } else {
      result = await db.query(notesTABLE, columns: columns, orderBy: 'id DESC');
    }

    List<Notes> notes = result.isNotEmpty
        ? result.map((item) => Notes.fromDatabaseJson(item)).toList()
        : [];
    return notes;
  }

  Future<int> updateNotes(Notes notes) async {
    final db = await dbProvider.database;

    var result = await db.update(notesTABLE, notes.toDatabaseJson(),
        where: "id = ?", whereArgs: [notes.id]);

    return result;
  }

  Future<int> deleteNotes(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(notesTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future<Notes> getNoteById({List<String> columns, int id}) async {
    final db = await dbProvider.database;
    var result = await db
        .query(notesTABLE, columns: columns, where: 'id = ?', whereArgs: [id]);

    List<Notes> notes = result.isNotEmpty
        ? result.map((note) => Notes.fromDatabaseJson(note)).toList()
        : [];
    Notes note = notes.isNotEmpty ? notes[0] : null;

    return note;
  }

  Future deleteAllNotes() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      notesTABLE,
    );

    return result;
  }
}
