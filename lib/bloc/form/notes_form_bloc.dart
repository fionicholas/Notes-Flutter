import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_sqflite_bloc/bloc/form/notes_form_state.dart';
import 'package:notes_sqflite_bloc/model/notes.dart';
import 'package:notes_sqflite_bloc/repository/notes_repository.dart';
import 'notes_form_event.dart';

class NotesFormBloc extends Bloc<NotesFormEvent, NotesFormState> {
  final NotesRepository noteRepository;

  NotesFormBloc({@required this.noteRepository}) : super(InitialNotesFormState());

  @override
  Stream<NotesFormState> mapEventToState(NotesFormEvent event) async* {
    yield NotesFormLoading();
    if (event is GetNoteItem) {
      try {
        yield NoteHasData(note: event.note?.id == null ? Notes() : await noteRepository.getNotesById(id : event.note?.id));
      } catch(e) {
        yield NotesFormError(e.toString());
      }
    }
    else if (event is BackEvent) {
      yield InitialNotesFormState();
    } else if (event is CreateNotes) {
      try {
        await noteRepository.insertNotes(event.note);
        yield Success(successMessage : event.note.title + ' created');
      } catch(e) {
        yield NotesFormError(e.toString());
      }
    } else if (event is UpdateNotes) {
      try {
        await noteRepository.updateNotes(event.note);
        yield Success(successMessage: event.note.title + ' updated');
      } catch(e) {
        yield NotesFormError(e.toString());
      }
    }
  }
}