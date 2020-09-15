import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_sqflite_bloc/bloc/form/notes_form_bloc.dart';
import 'package:notes_sqflite_bloc/bloc/list/notes_list_bloc.dart';
import 'package:notes_sqflite_bloc/bloc/list/notes_list_event.dart';
import 'package:notes_sqflite_bloc/bloc/notes_bloc_observer.dart';
import 'package:notes_sqflite_bloc/repository/notes_repository.dart';
import 'package:notes_sqflite_bloc/ui/notes_list_screen.dart';
import 'package:notes_sqflite_bloc/ui/theme.dart';

void main() {
  Bloc.observer = NotesBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Niko Notes',
        theme: theme(),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<NotesListBloc>(
              create: (context) {
                return NotesListBloc(noteRepository: NotesRepository())..add(GetNotes());
              },
            ),
            BlocProvider<NotesFormBloc>(
              create: (context) {
                return NotesFormBloc(noteRepository: NotesRepository());
              },
            )
          ],
          child: NotesListScreen(),
        ));
  }
}
