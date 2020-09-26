import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_notes/blocs/auth/auth_bloc.dart';
import 'package:bloc_notes/models/models.dart';
import 'package:bloc_notes/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'note_detail_event.dart';
part 'note_detail_state.dart';

class NoteDetailBloc extends Bloc<NoteDetailEvent, NoteDetailState> {
  final AuthBloc _authBloc;
  final NotesRepository _notesRepository;

  NoteDetailBloc({
    @required AuthBloc authBloc,
    @required NotesRepository notesRepository,
  })  : _authBloc = authBloc,
        _notesRepository = notesRepository;
  @override
  NoteDetailState get initialState => NoteDetailState.empty();
  @override
  Stream<NoteDetailState> mapEventToState(NoteDetailEvent event) async* {
    if (event is NoteLoaded) {
      yield* _mapNoteLoadedToState(event);
    } else if (event is NoteContentUpdated) {
      yield* _mapNoteContentUpdatedToState(event);
    } else if (event is NoteColorUpdated) {
      yield* _mapNoteColorUpdatedToState(event);
    } else if (event is NoteAdded) {
      yield* _mapNoteAddedToState();
    } else if (event is NoteSaved) {
      yield* _mapNoteSavedToState();
    } else if (event is NoteDeleted) {
      yield* _mapNoteDeletedToState();
    }
  }

  String _getCurrentUserId() {
    AuthState authState = _authBloc.state;
    String currentUserId;

    if (authState is Anonymous) {
      currentUserId = authState.user.id;
    } else if (authState is Authenticated) {
      currentUserId = authState.user.id;
    }
    return currentUserId;
  }

  Stream<NoteDetailState> _mapNoteLoadedToState(NoteLoaded event) async* {
    yield state.update(note: event.note);
  }

  Stream<NoteDetailState> _mapNoteContentUpdatedToState(
      NoteContentUpdated event) async* {
    if (state.note == null) {
      final currentUserId = _getCurrentUserId();
      final Note note = Note(
        userId: currentUserId,
        content: event.content,
        color: HexColor('#E74C3C'),
        timestamp: DateTime.now(),
      );
      yield state.update(note: note);
    } else {
      yield state.update(
        note: state.note.copy(
          content: event.content,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  Stream<NoteDetailState> _mapNoteColorUpdatedToState(
      NoteColorUpdated event) async* {
    if (state.note == null) {
      final currentUserId = _getCurrentUserId();
      final Note note = Note(
        userId: currentUserId,
        content: '',
        color: event.color,
        timestamp: DateTime.now(),
      );
      yield state.update(note: note);
    } else {
      yield state.update(
        note: state.note.copy(
          color: event.color,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  Stream<NoteDetailState> _mapNoteAddedToState() async* {
    yield NoteDetailState.submiting(note: state.note);
    try {
      await _notesRepository.addNote(note: state.note);
      yield NoteDetailState.success(note: state.note);
    } catch (e) {
      yield NoteDetailState.failure(
          note: state.note, errorMessage: 'New note could not be added');
    }
    // after showing the error we want to show something so  we call state.update()
    yield state.update(
      isSubmiting: false,
      isFailure: false,
      isSuccess: false,
      errorMessage: "",
    );
  }

  Stream<NoteDetailState> _mapNoteSavedToState() async* {
    yield NoteDetailState.submiting(note: state.note);
    try {
      await _notesRepository.updateNote(note: state.note);
    } catch (e) {
      yield NoteDetailState.failure(
        note: state.note,
        errorMessage: 'Note copuld note be saved',
      );
    }
    // after showing the error we want to show something so  we call state.update()
    yield state.update(
      isSubmiting: false,
      isFailure: false,
      isSuccess: false,
      errorMessage: "",
    );
  }

  Stream<NoteDetailState> _mapNoteDeletedToState() async* {
    yield NoteDetailState.submiting(note: state.note);
    try {
      await _notesRepository.deleteNote(note: state.note);
    } catch (e) {
      yield NoteDetailState.failure(
          note: state.note, errorMessage: 'Note could note be deleted');
    }
    // after showing the error we want to show something so  we call state.update()
    // or we can just call it resert the state
    yield state.update(
      isSubmiting: false,
      isFailure: false,
      isSuccess: false,
      errorMessage: "",
    );
  }
}
