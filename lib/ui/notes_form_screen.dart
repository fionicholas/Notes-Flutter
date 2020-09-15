import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_sqflite_bloc/bloc/form/notes_form_bloc.dart';
import 'package:notes_sqflite_bloc/bloc/form/notes_form_event.dart';
import 'package:notes_sqflite_bloc/bloc/form/notes_form_state.dart';
import 'package:notes_sqflite_bloc/bloc/list/notes_list_bloc.dart';
import 'package:notes_sqflite_bloc/bloc/list/notes_list_event.dart';
import 'package:notes_sqflite_bloc/model/notes.dart';
import 'package:notes_sqflite_bloc/ui/components/error_widget.dart';
import 'package:notes_sqflite_bloc/ui/components/loading_indicator.dart';

class NotesFormScreen extends StatefulWidget {
  static const routeName = '/notes_form';

  @override
  _NotesFormScreenState createState() => _NotesFormScreenState();
}

class _NotesFormScreenState extends State<NotesFormScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  NotesListBloc notesListBloc;
  NotesFormBloc notesFormBloc;

  @override
  void initState() {
    super.initState();
    notesListBloc = BlocProvider.of<NotesListBloc>(context);
    notesFormBloc = BlocProvider.of<NotesFormBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        notesFormBloc.add(BackEvent());
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: BlocBuilder<NotesFormBloc, NotesFormState>(
            builder: (context, state) =>
                Text((state.note?.id == null ? 'Add' : 'Edit') + ' Notes'),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: BlocListener<NotesFormBloc, NotesFormState>(
              listenWhen: (previousState, state) {
                return state is Success;
              },
              listener: (context, state) {
                notesListBloc.add(GetNotes());
                Navigator.pop(context);
              },
              child: BlocBuilder<NotesFormBloc, NotesFormState>(
                builder: (context, state) {

                  if (state is NoteHasData) {
                    Notes note = state.note?.id == null ? Notes() : state.note;
                    return buildForm(note);
                  }
                  if (state is NotesFormError) {
                    return error(state.errorMessage);
                  }
                  return LoadingIndicator();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForm(Notes notes) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(height: 10,),
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: "Title"),
            initialValue: notes?.title ?? '',
            onChanged: (value) {
              notes.title = value;
            },
            validator: (value) {
              if (value.length < 1) {
                return 'Title cannot be empty';
              }
              return null;
            },
          ),
          SizedBox(height: 20,),
          TextFormField(
            keyboardType: TextInputType.multiline,
            minLines: 4,
            maxLines: 6,
            decoration: InputDecoration(labelText: "Description"),
            initialValue: notes?.description ?? '',
            onChanged: (value) {
              notes.description = value;
            },
            validator: (value) {
              if (value.length < 1) {
                return 'Description cannot be empty';
              }
              return null;
            },
          ),
          SizedBox(
            height: 16,
          ),
          ButtonTheme(
            minWidth: size.width - 20,
            height: 50,
            child: RaisedButton(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.blue,
              child: Text(
                'Save Note',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  notesFormBloc.add(notes.id == null
                      ? CreateNotes(note: notes)
                      : UpdateNotes(note: notes));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
