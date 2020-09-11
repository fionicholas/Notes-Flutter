
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_sqflite_bloc/bloc/list/notes_list_event.dart';
import 'package:notes_sqflite_bloc/bloc/list/notes_list_state.dart';
import 'package:notes_sqflite_bloc/model/notes.dart';
import 'package:notes_sqflite_bloc/repository/notes_repository.dart';

class NotesListBloc extends Bloc<NotesListEvent, NotesListState>{
  final NotesRepository noteRepository;

  NotesListBloc({@required this.noteRepository}) : super(InitialNotesListState());

  @override
  Stream<NotesListState> mapEventToState(NotesListEvent event) async* {
    yield NotesListLoading();
    if (event is GetNotes) {
      try {
        List<Notes> notes = await noteRepository.getAllNotes(query: event.query);
        yield NotesHasData(notes);
      } catch(e) {
        yield NotesListError(e.toString());
      }
    }
    else if (event is DeleteNotes) {
      try {
        await noteRepository.deleteNoteById(event.note.id);
        yield NotesHasData(await noteRepository.getAllNotes(query: event.query));
      } catch(e) {
        yield NotesListError(e.toString());
      }
    }
  }

}
