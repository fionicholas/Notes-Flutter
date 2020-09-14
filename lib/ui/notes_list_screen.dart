import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_sqflite_bloc/bloc/form/notes_form_bloc.dart';
import 'package:notes_sqflite_bloc/bloc/form/notes_form_event.dart';
import 'package:notes_sqflite_bloc/bloc/form/notes_form_state.dart';
import 'package:notes_sqflite_bloc/bloc/list/notes_list_bloc.dart';
import 'package:notes_sqflite_bloc/bloc/list/notes_list_event.dart';
import 'package:notes_sqflite_bloc/bloc/list/notes_list_state.dart';
import 'package:notes_sqflite_bloc/model/notes.dart';
import 'package:notes_sqflite_bloc/ui/components/loading_indicator.dart';
import 'package:notes_sqflite_bloc/ui/components/no_data_widget.dart';
import 'package:notes_sqflite_bloc/ui/notes_form_screen.dart';

import 'components/error_widget.dart';
import 'components/snackbar_widget.dart';

class NotesListScreen extends StatefulWidget {
  static const routeName = '/notes_list';

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  NotesListBloc notesListBloc;

  NotesFormBloc notesFormBloc;

  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    notesListBloc = BlocProvider.of<NotesListBloc>(context);
    notesFormBloc = BlocProvider.of<NotesFormBloc>(context);
    notesListBloc.add(GetNotes());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Niko Notes')),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<NotesFormScreen>(
                builder: (context) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<NotesFormBloc>.value(
                          value: notesFormBloc..add(GetNoteItem())),
                      BlocProvider<NotesListBloc>.value(value: notesListBloc),
                    ],
                    child: NotesFormScreen(),
                  );
                },
              ),
            );
          }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * 1 / 8,
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _searchController,
                autocorrect: false,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      notesListBloc
                          .add(GetNotes(query: _searchController.text));
                    },
                  ),
                  hintText: 'Search...',
                ),
              ),
            ),
            Container(
              height: size.height * 6 / 8,
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  notesListBloc.add(GetNotes());
                },
                child: BlocListener<NotesFormBloc, NotesFormState>(
                  listenWhen: (previousState, state) {
                    return state is Success;
                  },
                  listener: (context, state) {
                    if (state.message.isNotEmpty) {
                      _scaffoldKey.currentState
                          .showSnackBar(snackBar(state.message));
                    }
                  },
                  child: BlocBuilder<NotesListBloc, NotesListState>(
                      builder: (context, state) {
                    if (state is NotesHasData) {
                      return Container(
                          margin: EdgeInsets.all(8),
                          child: (state?.notes?.isNotEmpty ?? true
                              ? ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state.notes.length,
                                  itemBuilder: (context, index) {
                                    Notes note = state.notes[index];
                                    return _userCard(note, context);
                                  },
                                )
                              : NoData()));
                    }
                    if (state is NotesListError) {
                      return error(state.errorMessage);
                    }
                    return LoadingIndicator();
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _userCard(Notes note, BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          note.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Text(note.description)),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<NotesFormScreen>(
                            builder: (context) {
                              return MultiBlocProvider(
                                providers: [
                                  BlocProvider<NotesFormBloc>.value(
                                      value: notesFormBloc
                                        ..add(GetNoteItem(note: note))),
                                  BlocProvider<NotesListBloc>.value(
                                      value: notesListBloc),
                                ],
                                child: NotesFormScreen(),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        notesListBloc.add(DeleteNotes(note: note));
                        _scaffoldKey.currentState
                            .showSnackBar(snackBar(note.title + ' deleted'));
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
