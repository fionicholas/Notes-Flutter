import 'package:equatable/equatable.dart';
import 'package:notes_sqflite_bloc/model/notes.dart';

abstract class NotesListState extends Equatable {
  const NotesListState();

  @override
  List<Object> get props => [];
}

class InitialNotesListState extends NotesListState {}

class NotesListLoading extends NotesListState {}

class NotesListError extends NotesListState {
  final String errorMessage;
  const NotesListError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'Notes List Failure --> message: $errorMessage';

}

class NotesHasData extends NotesListState {
  final List<Notes> notes;

  const NotesHasData([this.notes]);

  @override
  List<Object> get props => [notes];
}
