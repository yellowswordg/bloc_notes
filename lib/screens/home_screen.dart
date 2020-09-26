import 'package:bloc_notes/blocs/auth/auth_bloc.dart';
import 'package:bloc_notes/blocs/blocs.dart';

import 'package:bloc_notes/repositories/notes/notes_repository.dart';
import 'package:bloc_notes/screens/screens.dart';
import 'package:bloc_notes/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Fetch the notes, coz whenever we logs in we fetch new notes for user that loged in
        context.bloc<NotesBloc>().add(FetchNotes());
      },
      builder: (BuildContext context, autState) {
        return Scaffold(
          body: BlocBuilder<NotesBloc, NotesState>(
            builder: (context, notesState) {
              return _buildBody(context, autState, notesState);
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider<NoteDetailBloc>(
                  create: (context) => NoteDetailBloc(
                      authBloc: context.bloc<AuthBloc>(),
                      notesRepository: NotesRepository()),
                  child: NoteDetailScreen(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Stack _buildBody(
    BuildContext context,
    AuthState authState,
    NotesState noteState,
  ) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              //helps to float appBar
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Your Notes'),
              ),
              leading: IconButton(
                icon: authState is Authenticated
                    ? Icon(Icons.exit_to_app)
                    : Icon(Icons.account_circle),
                iconSize: 28.0,
                onPressed: () {
                  authState is Authenticated
                      ? context.bloc<AuthBloc>().add(Logout())
                      : print('go to login');
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.brightness_4),
                  onPressed: () => print('Change Theme'),
                )
              ],
            ),
            noteState is NotesLoaded
                ? NotesGrid(
                    notes: noteState.notes,
                    onTap: (note) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider<NoteDetailBloc>(
                          create: (context) => NoteDetailBloc(
                              authBloc: context.bloc<AuthBloc>(),
                              notesRepository: NotesRepository())
                            ..add(NoteLoaded(note: note)),
                          child: NoteDetailScreen(),
                        ),
                      ),
                    ),
                  )
                : const SliverPadding(
                    padding: EdgeInsets.zero,
                  ),
          ],
        ),
        noteState is NotesLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox.shrink(),
        noteState is NotesError
            ? Center(
                child: Text(
                  'Something went wrong! \n Please check your connection!',
                  textAlign: TextAlign.center,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
