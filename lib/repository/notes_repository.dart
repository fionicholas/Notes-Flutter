import 'package:notes_sqflite_bloc/dao/notes_dao.dart';
import 'package:notes_sqflite_bloc/model/notes.dart';

class NotesRepository {
  final notesDao = NotesDao();

  Future getAllNotes({String query}) => notesDao.getNotes(query: query);

  Future getNotesById({int id}) => notesDao.getNoteById(id: id);

  Future insertNotes(Notes notes) => notesDao.createNotes(notes);

  Future updateNotes(Notes notes) => notesDao.updateNotes(notes);

  Future deleteNoteById(int id) => notesDao.deleteNotes(id);

  Future deleteAllNotes() => notesDao.deleteAllNotes();
}