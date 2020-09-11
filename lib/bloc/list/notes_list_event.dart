
import 'package:equatable/equatable.dart';
import 'package:notes_sqflite_bloc/model/notes.dart';

abstract class NotesListEvent extends Equatable {
  final Notes note;
  final String query;

  const NotesListEvent({this.note, this.query});

  @override
  List<Object> get props => [note, query];
}

class GetNotes extends NotesListEvent {
  GetNotes({String query}) : super(query : query);
}

class DeleteNotes extends NotesListEvent {
  DeleteNotes({Notes note}) : super(note : note);
}