import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes_sqflite_bloc/model/notes.dart';

abstract class NotesFormState extends Equatable {

  final String message;
  final Notes note;
  const NotesFormState({this.message, this.note});

  @override
  List<Object> get props => [];
}

class InitialNotesFormState extends NotesFormState {}

class NotesFormLoading extends NotesFormState {}

class NotesFormError extends NotesFormState {
  final String errorMessage;

  const NotesFormError(this.errorMessage);

  List<Object> get props => [errorMessage];

  @override
  String toString() => 'Notes Form No Data (message : $errorMessage)';
}

class NoteHasData extends NotesFormState {
  const NoteHasData({@required Notes note}) : super(note : note);
}

class Success extends NotesFormState {
  Success({@required String successMessage}) : super(message: successMessage);
}