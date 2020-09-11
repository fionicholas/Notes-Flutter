import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:notes_sqflite_bloc/model/notes.dart';

abstract class NotesFormEvent extends Equatable {
  final Notes note;

  const NotesFormEvent({this.note});

  @override
  List<Object> get props => [note];
}

class BackEvent extends NotesFormEvent {}

class GetNoteItem extends NotesFormEvent {
  GetNoteItem({Notes note}) : super(note: note);
}

class CreateNotes extends NotesFormEvent {
  CreateNotes({@required Notes note}) : super(note: note);
}

class UpdateNotes extends NotesFormEvent {
  UpdateNotes({@required Notes note}) : super(note: note);
}
